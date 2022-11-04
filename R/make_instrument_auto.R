#' Extract an Instrument from an REDCap Export without specifying Variables
#'
#' @description This function takes a data frame holding REDCap data,
#' checks if it is a longitudinal study, and returns records that have values.
#'
#'
#' @param df A data frame with the instrument
#' @param drop_which_when Drop the `record_id` and `redcap_event_name` variables
#' @param record_id Name of `record_id` variable (if it was changed in REDCap)
#'
#' @return A data frame that has an instrument (with at least one not NA value).
#'
#' @export
#'
## @examples
make_instrument_auto <- function(df, drop_which_when = FALSE,
                                 record_id = "record_id") {
  # browser()
  if (names(df)[1] != record_id) {
    stop("The first variable in df must be `record_id`", call. = FALSE)
  }

  # Strip labels from REDCap created variables to prevent reported join (and 
  #   perhaps pivot) issues on labeled variables.
  df <- drop_label(df, record_id)
  

  is_longitudinal <- any(names(df) == "redcap_event_name")
  
  if(is_longitudinal){
    df <- drop_label(df, "redcap_event_name")
  }
  
  is_repeated <- any(names(df) == "redcap_repeat_instrument")

  if(is_repeated){
    df <- drop_label(df, "redcap_repeat_instrument")
    df <- drop_label(df, "redcap_repeat_instance")
  }

  # if there are repeated instruments check to see if this instrument has repeats
  
  # part of a solution for checcking to see if this is a repeated form
  #if (is_repeated) {
  #  has_repeat_number <- any(!is.na(df$redcap_repeat_instance))
  #} else {
  #  has_repeat_number <- FALSE
  #}

  # Get the first column of instrument specific data
  #if (is_longitudinal & is_repeated & ! has_repeat_number){
  #  first_col <- 5
  #} else if (is_longitudinal & is_repeated & has_repeat_number){
  #  first_col <- 4
  #} else if (is_repeated & ! has_repeat_number) {
  #  first_col <- 4
  #}  else if (is_repeated & has_repeat_number) {
  #  first_col <- 3
  #} else if (is_longitudinal) {
  #  first_col <- 3
  #} else {
  #  first_col <- 2
  #}
  
  if (is_longitudinal & is_repeated){
    first_col <- 5
  } else if (is_repeated ) {
    first_col <- 4
  } else if (is_longitudinal) {
    first_col <- 3
  } else {
    first_col <- 2
  }
  
  
  
  
  # replaced by above
  #if (is_longitudinal) {
  #  first_col <- 3
  #} else {
  #  first_col <- 2
  #}

  last_col <- length(names(df))

  # browser()
  df <- fix_class_bug(df)


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

#' Fix labelled class bug
#' @description This fixes a bug if variable class is both "labelled" and
#'   "hms" and "labelled" class is before "hms". For example:
#'   * "Error in as.character(x) : Can't convert `x` \<time\> to \<character\>.
#'   * The print method with data.frame is broken, but works with tibble.
#'   * Neither the `str()` nor `View()` function works.
#'
#' @param df
#'
#' @noRd
#'
#' @return df
fix_class_bug <- function(df) {
  # Make a list of classes for all dataframe variables
  classes_ls <- lapply(df, class)

  # Creating generic function to move first element of vector to the end
  # if the first element is "labelled" and if it is before "hms"
  move_to_end <- function(x) {
    if ("labelled" %in% x && "hms" %in% x) {
      if (which(x == "hms") > which(x == "labelled")) {
        x[c(which(x != "labelled"), which(x == "labelled"))]
      } else {
        x <- x
      }
    } else {
      x <- x
    }
  }

  # Applying the move_to_end function to all of the class names. That is
  #   move "labelled" to the last element of the class vector.  This
  #   circumvents the "labelled"-"hms" bug.

  classes2_ls <- lapply(
    X = classes_ls,
    FUN = move_to_end
  )

  # Applying the change class names to the exported REDCap data.
  for (i in 1:ncol(df)) {
    class(df[, i]) <- classes2_ls[[i]]
  }

  return(df)
}
"fix_class_bug"


#' Drop the label from a variable
#' @description There is a reported issues with joins on data (without a reprex)
#' that seem to be caused by the labels.  As a possible solution this can be 
#' used to drop labels.
#'
#' @param df the name of the data frame
#' @param x the quoted name of the variable
#'
#' @noRd
#' @export
#'
#' @return df
drop_label <- function(df, x) {
  attributes(df[, which(names(df) == x)]) <- NULL
  df
}

