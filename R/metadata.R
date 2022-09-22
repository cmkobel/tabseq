
#' Extracts key=value; pair information in the comment column
#' @export
#' @import magrittr
#' @import readr
#' @description This function expands tabseq comment key-value pair contents into several columns
#' @param tabseq A tabseq tibble
#' @param output_wide Disables the internal pivot_wide call. Defaults to TRUE. By setting this to FALSE you get a longer table instead, with is also computed faster.
#' @param include_sequence Includes the sequence column in the return value. Defaults to TRUE. By setting this to FALSE you will get a table without sequences, which is also computed faster.
#' @return A tabseq tibble
#' @examples
expand_attributes = function(tabseq, output_wide = TRUE, include_sequence = TRUE, ...) {
    # The user might want to save cpu time by not performing the pivet_wider
    # step. Same step goes for left_joining. That is the reason why the two
    # arguments output_wide and include_sequence exist.
    rv = tabseq |>
        dplyr::select(sample, part, comment) |>

        # Way too heavy to drag the sequence along here.
        # Remember that each marginal key=value; pair becomes a row.
        # Therefore we will join it later.
        dplyr::mutate(comment = str_split(comment, ";"))  |>

        tidyr::unnest(cols = comment) |>
        tidyr::separate(col = comment, into = c("name", "value"), sep = "=") %>%
        dplyr::filter(!is.na(value))  # removes empty rows if attributes are ending with a semi-colon (;)


    # Pivot wider step
    if (output_wide) {
        rv = pivot_wider(rv, id_cols = c(sample, part), names_prefix = "ts_", ...)
    }

    # Add the sequence back on
    if (include_sequence) {
        rv = left_join(x = rv,
                       y = tabseq |> select(sample, part, sequence),
                       by = c("sample", "part"))
    }

    rv
}


#condense_attributes


