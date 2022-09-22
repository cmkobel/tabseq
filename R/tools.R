

#' Invoke View without the sequence column
#' @export
#' @import stringr
#' @import utils
#' @description Calculates GC, GC1 GC2 or GC3 for a given sequence.
#' @param input A tabseq table
#' @return A list of two items: annotation and fasta. The fasta item is read with tabseq::read_fasta
#' @examples
tsView = function(input) {
    #message("version x24")
    input %>%
        mutate(sequence = paste(str_sub(sequence, 1, 10), "(..)")) %>%
        utils::View(title = paste("tabseq View"))
}
