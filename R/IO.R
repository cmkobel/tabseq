#' Read a fasta file and convert it to tabseq
#' @export
#' @import dplyr stringr tidyr readr
#' @description Takes the path to a fasta file. Loads the fasta file, and converts it to a tabseq table.
#' @param file The path to a fasta-file
#' @param basename_only If TRUE, the full paths to the files will be truncated in favor of the basename only
#' @param skip Skip this number of lines in the file before reading
#' @return A tibble containing the respective records and sequences from the fasta-file, represented in the tabseq format.
#' @examples
#'
#' #my_sequences = read_tabseq("path/to/sequences.fa")
#'
read_fasta = function(file, basename_only = T, remove_extension = F, skip = 0) {

    # For spontaneous debugging:
    # file = "~/assemblycomparator2/tests/E._faecium_plasmids/VB3240.fna"

    # Format the input file for use in the sample column
    file_presentable = file
    if (basename_only) {
        file_presentable = basename(file_presentable)
    }
    if (remove_extension) {
        file_presentable_splitted = strsplit(file_presentable, "\\.") |> unlist()
        file_presentable = paste(file_presentable_splitted[1:(length(file_presentable_splitted))-1], collapse = ".")
        # Really disappointed in my self, that I couldn't get this below two lines.
    }

    # Open the file
    message(paste("reading", file, "as fasta", "\n"))

    file_open = scan(file, what = character(), sep = "\n", quiet = T, comment.char = "#") # Not sure about that nmax + 1 thing.


    rv = dplyr::tibble(raw = file_open[(skip+1):length(file_open)]) %>% # +1 on the skip because skip=1 would actually mean skip none. Why am I not using skip built into scan instead?

        # detect record headers
        dplyr::mutate(header = dplyr::if_else(stringr::str_sub(raw, 1, 1) == ">", T, F)) %>%

        # enumerate the record headers and fill the downwards through the sequence lines
        dplyr::mutate(header_num = ifelse(header, seq.int(nrow(.)), NA)) %>% # needs no sorting
        tidyr::fill(header_num, .direction = "down") %>%

        # Collect the lines for each record
        dplyr::group_by(header_num) %>%
        dplyr::summarize(part = stringr::str_sub(raw[1], 2),
                         sequence = paste(raw[-1], collapse = ""), .groups = "drop") %>%

        dplyr::mutate(comment = paste("record", dplyr::row_number(header_num))) %>%  # reset header nums
        #identity()
        dplyr::transmute(sample = file_presentable, part, comment, sequence)

    #cat(paste("parsed", (rv %>% dim)[1], "records", "\n"))
    message(paste("parsed", (rv %>% dim)[1], "records", "\n"))


    rv

}


# TODO: The complement function should really be called iupac_complement

#' Read a GFF3 file
#' @export
#' @description Read a GFF3 file
#' @import tidyr
#' @param file A GFF3 file
#' @param parse_attributes Whether the `attributes` column in the gff should be parsed into separate columns
#' @return A list of two items: annotation and fasta. The fasta item is read with tabseq::read_fasta()
#' @examples
read_gff = function(file, parse_attributes = TRUE) {

    col_names = c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes") # Source: https://m.ensembl.org/info/website/upload/gff3.html

    # For debugging
    #file = "~/assemblycomparator2/tests/E._faecium_plasmids/output_asscom2/samples/VB3240/prokka/VB3240.gff"

    # Find the line number where the fasta file starts
    file_open = scan(file, what = "character", sep = "\n", quiet = T)
    annotation_fasta_split_line_number = str_detect(file_open, "^##FASTA") |> which()
    # If there is a fasta part in the gff file, read it with tabseq.
    if(annotation_fasta_split_line_number |> length() > 0) {
        write(paste("splitting the file between annotation and fasta at line number:", annotation_fasta_split_line_number), stderr())

        fasta = tabseq::read_fasta(file, skip = annotation_fasta_split_line_number - 1) # Be informed that when you use the skip argument, it counts exclusive of comment lines. Fortunately, no comment argument has been implemented in tabseq::read_fasta().
    } else {
        warning("The gff file doesn't contain a fasta part. The fasta item in the return value will be `NA`")
        fasta = NA
    }

    annotation = read_tsv(file_open[1:(annotation_fasta_split_line_number - 1)], col_names = col_names, comment = "##") %>%
        # View()
        identity()

    list(annotation = annotation, fasta = fasta)
}



# TODO: Consider implementing a View function that strips or simplifies the sequence column.




#' Simplify the sequence column for development purposes
#' @export
#' @import stringr tidyr
#' @description Truncates the sequence column
#' @param input A string of nucleotides
#' @return A list of two items: annotation and fasta. The fasta item is read with tabseq::read_fasta()
#' @examples
ts_neutralize = function(input) {
    message("version x24")
    input %>%
        mutate(sequence = paste(str_sub(sequence, 1, 10), "(..)"))
}



#' Convenience function for reading tabseqs
#' @export
#' @import readr
#' @description Imports a tabseq with the correct column types
#' @param input A tabseq path/filename
#' @return A tibble containing the input tabseq content.
#' @examples
read_tabseq = function(input) {
    readr::read_tsv(file = input,
             col_names = c("sample", "part", "auxiliary", "sequence"),
             col_types = readr::cols(.default = readr::col_character()),
             comment = "#")

    # Todo: check for duplicate pairs in sample/part
}




#' Write a tabseq table to disk in fasta-format.
#' @export
#' @import dplyr tidyr stringr
#' @description Takes a tabseq table, and saves it to disk in the fasta format.
#' @param x The tabseq table to save
#' @param file The path to a wanted fasta-file
#' @param format The format you want to save the file as
#' @param record_format A string designating how to encode the records in the fasta file written. Defaults to "\%part", but may be a combination of all metadata columns including custom separators i.e. "\%sample|\%part|\%comment.
#' @param verbose For debugging
#' @return Saves the content to disk, and returns a tibble which represents what is being written to disk.
#' @examples
#'
#' #my_sequences = read_tabseq("path/to/sequences.fa")
#' #write_tabseq(my_sequences, "write/sequences/here/sequences.fa")
write_fasta = function(x, file, format = "fasta", record_format = "%part", verbose = F) {

    if (format == "fasta") {

        message(paste("writing to file ", file, "as fasta"))
        message(paste("using the following record_format:", record_format))


        # The only reason I'm placing the record definition before making the 'formatted' variable, is because I want to be able to verbosely read the contents of it.
        record = stringr::str_replace_all(record_format, "%sample", as.character(x$sample)) %>%
            stringr::str_replace_all("%part", as.character(x$part)) %>%
            stringr::str_replace_all("%comment", as.character(x$comment))

        if (verbose) {
            print(record)
        }


        # format as "fasta"
        formatted = x %>%
            dplyr::mutate(record_format = record_format) %>%
            dplyr::transmute(record = record, sequence = sequence)





        # Interleave
        interleave = as.vector(rbind(paste0(">", formatted$record), formatted$sequence))


        fileConn<-file(file)
        writeLines(interleave, fileConn)
        close(fileConn)

        #cat("\n")
        #cat(paste0(">", formatted$record, "\t", str_sub(formatted$sequence, 1, 10), "...", collapse = "\n"))
        formatted
    }

}




