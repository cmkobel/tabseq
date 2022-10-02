
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




# This function is not exported
GC_content_nonvectorized = function(string, position = 0) {
    #string = "agcccatgtgaccagc"
    #string = "AbbCdd"

    # Uppercase as a means of homogenization
    string = string |> toupper()

    # Each item in `splitted` is now a single character
    splitted = string |>
        strsplit("") |>
        unlist()


    if (position != 0 & position >= 1 & position <= 3) {
        #write(paste0("Info: Calculating GC", position, "."), stderr())
        splitted = splitted[(1:length(splitted)-1)%%3 == (position -1)]
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


#' Calculate GC content
#' @export
#' @import stringr dplyr
#' @description Calculates GC, GC1 GC2 or GC3 for a given sequence.
#' @param string A string of nucleotides
#' @param position The position to look for GC at. 0 (default) means all, 1 means GC1, 2 means GC2 and 3 means GC3.
#' @return A list of two items: annotation and fasta. The fasta item is read with tabseq::read_fasta()
#' @examples
GC_content = function(string, position = 0) {
    message("calling vectorized edition")

    # Simply call the non vectorized function above, and pass the arguments.
    rv = Vectorize(GC_content_nonvectorized, vectorize.args = "string")(string, position)
    names(rv) = NULL
    rv
}



#' Measure k-mer counts
#' @export
#' @import stringr dplyr
#' @description Counts occurrences of k-mers
#' @param k the length of the mers wanted. Each of 4^k mers will be measured.
#' @param sequence A sequence of nucleotides
#' @return An array of lexicographically sorted k-mers counts.
#' @examples
ts_kmer_count = function(k, sequence) {
    kmer_count(sequence)
}
