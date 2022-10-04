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
make_instrument_auto <- function(df, record_id="record_id", drop_which_when = FALSE) {
  #browser()
  if (names(df)[1] != record_id) {
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
  
  #the_tibble_df <- tibble::as_tibble(df)
  browser()
  
  # labelled class with hms causes 
  #  "Error in as.character(x) : Can't convert `x` <time> to <character>.
  
  classes_ls <- lapply(df, class)
  
  # check_hms <- function(x) {
  #   "hms" %in% x
  # }
  move_to_end <- function(x) {
    c(x[2:length(x)], x[1])
  }
  
  # has_hms <- vapply(classes_ls, FUN = check_hms, FUN.VALUE = logical(1)) 
  
  classes2_ls <- classes_ls
  classes2_ls <- lapply(
    X = classes_ls,
    FUN = move_to_end
  )
  
  for (i in 1:ncol(df)){
    class(df[,i]) <- classes2_ls[[i]]
  }
    
  # the instrument's content
  instrument <- df[, c(first_col:last_col), drop = FALSE]

  # which records are all missing
  allMissing <- apply(instrument, 1, function(x) {
    all(is.na(x) | x == "")
  })

  # the rows that are not all missing
  if (drop_which_when == FALSE) {
    if (is_longitudinal) {
      # get the column number for the id and event name
      record_id_col <- which(colnames(df) == record_id)
      redcap_event_name_col <- which(colnames(df) == "redcap_event_name")

      return(df[!allMissing, c(
        record_id_col,
        redcap_event_name_col,
        first_col:last_col
      )])
    } else {
      # get the column number for the id and event name
      record_id_col <- which(colnames(df) == record_id)

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
