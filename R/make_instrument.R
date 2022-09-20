#' Extract an Instrument from an REDCap Export
#'
#' @description This function takes a data frame and the names of the first and
#' last variables in an instrumnt and returns a data frame with the instrument.
#'
#' @param df A data frame with the instrument
#' @param first_var The name of the first variable in an instrument
#' @param last_var The name of the last variable in an instrument
#' @param drop_which_when Drop the `record_id` and `redcap_event_name` variables
#'
#' @return A data frame that has an instrument (with at least one not NA value)
#'
#' @export
#'
## @examples
make_instrument <- function(df, first_var, last_var, drop_which_when = FALSE) {
  if (!any(class(df) == "data.frame")) {
    stop("The `df` argument must be of class data.frame.",
      call. = FALSE
    )
  }
  if (!any(names(df) == first_var)) {
    stop(
      paste(
        "The `first_var` variable",
        first_var, "is not in the table."
      ),
      call. = FALSE
    )
  }
  if (!any(names(df) == last_var)) {
    stop(
      paste(
        "The `last_var` variable",
        last_var,
        "is not in the table."
      ),
      call. = FALSE
    )
  }

  # get the column numbers for the first and last variables
  first_col <- which(colnames(df) == first_var)
  last_col <- which(colnames(df) == last_var)

  # the instrument's content
  instrument <- df[, c(first_col:last_col)]

  # which records are all missing
  allMissing <- apply(instrument, 1, function(x) {
    all(is.na(x) | x == "")
  })

  # the rows that are not all missing
  if (drop_which_when == FALSE) {
    # get the column number for the id and event name
    record_id_col <- which(colnames(df) == "record_id")
    redcap_event_name_col <- which(colnames(df) == "redcap_event_name")

    return(df[!allMissing, c(
      record_id_col,
      redcap_event_name_col,
      first_col:last_col
    )])
  } else {
    return(df[!allMissing, c(first_col:last_col)])
  }
}
