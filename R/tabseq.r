#' Read a fasta file and convert it to tabseq
#' @export
#' @import dplyr stringr tidyr readr
#' @description Takes the path to a fasta file. Loads the fasta file, and converts it to a tabseq table.
#' @param file The path to a fasta-file
#' @param basename_only If TRUE, the full paths to the files will be truncated in favor of the basename only
#' @param skip Skip this number of lines in the file before reading
#' @return A tibble containing the respective records and sequences from the fasta-file. Represented in the tabseq format.
#' @examples
#'
#' #my_sequences = read_tabseq("path/to/sequences.fa")
#'
read_fasta = function(file, basename_only = T, skip = 0) {

    # For spontaneous debugging:
    # file = "~/assemblycomparator2/tests/E._faecium_plasmids/VB3240.fna"

    if (basename_only) {
        file_presentable = basename(file)
    } else {
        file_presentable = file
    }

    # Open the file
    cat(paste("reading", file, "as fasta", "\n"))
    file_open = scan(file, what = "character", sep = "\n", quiet = T)


    rv = dplyr::tibble(raw = file_open[(skip+1):length(file_open)]) %>%

        # detect record headers
        dplyr::mutate(header = if_else(stringr::str_sub(raw, 1, 1) == ">", T, F)) %>%

        # enumerate the record headers and fill the downwards through the sequence lines
        dplyr::mutate(header_num = ifelse(header, seq.int(nrow(.)), NA)) %>% # needs no sorting
        tidyr::fill(header_num, .direction = "down") %>%

        # Collect the lines for each record
        dplyr::group_by(header_num) %>%
        dplyr::summarize(part = stringr::str_sub(raw[1], 2),
                         sequence = paste(raw[-1], collapse = ""), .groups = "drop") %>%

        dplyr::mutate(comment = paste("record", dplyr::row_number(header_num))) %>%  # reset header nums

        dplyr::transmute(sample = file_presentable, part, comment, sequence)

    cat(paste("parsed", (rv %>% dim)[1], "records", "\n"))

    rv




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

        cat(paste("writing to file ", file, "as fasta", "\n"))
        cat(paste("using the following record_format:", record_format, "\n"))


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

# TODO: The complement function should really be called iupac_complement

#' Complement nucleotide letters
#' @export
#' @description Takes a string of IUPAC nucleotide letters and complements them.
#' @param string A string of DNA i.e. "ACGTTTN"
#' @param reverse Whether the string should be reversed or not (default TRUE)
#' @param type String type. (default "nucleotide")
#' @return A string which represents the chemical complements of the given input string
#' @examples
reverse_complement = function(string, reverse = TRUE, type = "nucleotide") {

    if (type == "nucleotide") {
        # Spontaneous debugging
        #string = "atgtcnNe"

        # Define a mapping 1:1
        mapping = c(
            # lower case
            "a" = "t", "t" = "a", "u" = "a", "c" = "g", "g" = "c", # lower case nucleotides
            "y" = "r", "r" = "y", "s" = "s", "w" = "w", "k" = "m", "m" = "k", # Two letter codes
            "b" = "v", "v" = "b", "d" = "h", "h" = "d", # Three letter codes
            "-" = "-", "n" = "n", # Miscellaneous

            # UPPER CASE
            "A" = "T", "T" = "A", "U" = "A", "C" = "G", "G" = "C", # LOWER CASE NUCLEOTIDES
            "Y" = "R", "R" = "Y", "S" = "S", "W" = "W", "K" = "M", "M" = "K", # TWO LETTER CODES
            "B" = "V", "V" = "B", "D" = "H", "H" = "D", # THREE LETTER CODES
            "-" = "-", "N" = "N") # MISCELLANEOUS


        #splitted = unlist(strsplit(string, ""))
        splitted = string |> strsplit("") |> unlist()
        rv = mapping[splitted] #%>% paste(collapse = "")

        NAs = sum(is.na(rv))
        if (NAs > 0) {
            warning(paste(NAs, "occurrences of unsupported charactors were complemented to a question mark:", paste(unique(splitted[is.na(rv)]), collapse = " ")))

            rv[is.na(rv)] = "?"
        }
    } else {
        stop("Only type \"nucleotide\" is supported for now.")
    }


    if (reverse) {
        rv = rev(rv)
    }

    paste(rv, collapse = "")
}

#"atugcyrswkmbdhvnatgatgatgatgATUGCYRSWKMBDHVNATGATGATGATG" |> reverse_complement() |> reverse_complement()
# attgcyrswkmbdhvnatgatgatgatgATTGCYRSWKMBDHVNATGATGATGATG



#' Read a GFF3 file
#' @export
#' @description Read a GFF3 file
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

    annotation = read_tsv(file_open[1:(annotation_fasta_split_line_number - 1)], col_names = col_names, comment = "##") |>
        # View()
        identity()

    list(annotation = annotation, fasta = fasta)
}


#' Calculate GC content
#' @export
#' @description Calculates GC, GC1 GC2 or GC3 for a given sequence.
#' @param string A string of nucleotides
#' @param position The position to look for GC at. 0 means all, 1 means GC1, 2 means GC2 and 3 means GC3.
#' @return A list of two items: annotation and fasta. The fasta item is read with tabseq::read_fasta()
#' @examples
GC_content = function(string, position = 0) {

    #string = "agcccatgtgaccagc"
    #string = "AbbCdd"

    string = string |> toupper()
    splitted = string |>
        strsplit("") |>
        unlist()


    if (position != 0 & position >= 1 & position <= 3) {
        #write(paste0("Info: Calculating GC", position, "."), stderr())
        splitted = splitted[(1:length(splitted)-1)%%3 == (position -1)]
        #write(paste0(splitted, collapse = ""), stderr())
    } else if (position == 0) {
        #write(paste0("Info: Calculating GC in all positions."), stderr())
    } else {
        stop("Invalid position. Please choose 0 (all positions) or 1 through 3 for GC1 through GC3, respectively.")
    }


    Gs = (splitted == "G") |> sum()
    Cs = (splitted == "C") |> sum()

    GCs = Gs + Cs

    GCs/length(splitted)

}



# TODO: Consider implementing a View function that strips or simplifies the sequence column.






