#' Extract an Instrument from an REDCap Export without specifying Variables
#'
#' @description This function takes a data frame holding REDCap data,
#' checks if it is a longitudinal study, and returns records that have values.
#'
#'
#' @param df A data frame with the instrument
#' @param drop_which_when Drop the `record_id` and `redcap_event_name` variables
#'
#' @return A data frame that has an instrument (with at least one not NA value).
#'
#' @export
#'
## @examples
make_instrument_auto <- function(df, drop_which_when = FALSE) {
  # browser()

  if (names(df)[1] != "record_id") {
    stop("The first variable in df must be `record_id`", call. = FALSE)
  }


  is_longitudinal <- any(names(df) == "redcap_event_name")

  # Get the first column of instrument specific data
  if (is_longitudinal) {
    first_col <- 3
  } else {
    first_col <- 2
  }

  last_col <- length(names(df))

  # the instrument's content
  instrument <- df[, c(first_col:length(names(df))), drop = FALSE]

  # which records are all missing
  allMissing <- apply(instrument, 1, function(x) {
    all(is.na(x) | x == "")
  })

  # the rows that are not all missing
  if (drop_which_when == FALSE) {
    if (is_longitudinal) {
      # get the column number for the id and event name
      record_id_col <- which(colnames(df) == "record_id")
      redcap_event_name_col <- which(colnames(df) == "redcap_event_name")

      return(df[!allMissing, c(
        record_id_col,
        redcap_event_name_col,
        first_col:last_col
      )])
    } else {
      # get the column number for the id and event name
      record_id_col <- which(colnames(df) == "record_id")

      return(df[!allMissing, c(
        record_id_col,
        first_col:last_col
      )])
    }
  } else {
    return(df[!allMissing, c(first_col:last_col)])
  }
}
"make_instrument_auto"
