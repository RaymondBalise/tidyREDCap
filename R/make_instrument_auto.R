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
make_instrument_auto <- function(
  df,
  drop_which_when = FALSE,
  record_id = "record_id"
) {
  if (names(df)[1] != record_id) {
    stop(
      "
         The first variable in df must be `record_id`;
         use option 'record_id=' to set the name of your custom id.",
      call. = FALSE
    )
  }

  # Strip labels from REDCap created variables to prevent reported join (and
  #   perhaps pivot) issues on labeled variables.
  df <- drop_label(df, record_id)

  is_longitudinal <- any(names(df) == "redcap_event_name")

  if (is_longitudinal) {
    df <- drop_label(df, "redcap_event_name")
  }

  is_repeated <- any(names(df) == "redcap_repeat_instrument")

  if (is_repeated) {
    df <- drop_label(df, "redcap_repeat_instrument")
    df <- drop_label(df, "redcap_repeat_instance")
  }

  # if there are repeated instruments check to see if this instrument has repeats
  if (is_longitudinal & is_repeated) {
    first_col <- 5
  } else if (is_repeated) {
    first_col <- 4
  } else if (is_longitudinal) {
    first_col <- 3
  } else {
    first_col <- 2
  }

  last_col <- length(names(df))

  df <- fix_class_bug(df)

  # the instrument's content
  instrument <- df[, c(first_col:last_col), drop = FALSE]

  # which records are all missing
  allMissing <- apply(instrument, 1, function(x) {
    all(is.na(x) | x == "")
  })

  # the rows that are not all missing.
  if (drop_which_when == FALSE) {
    # get the column number for the id and event name
    record_id_col <- which(colnames(df) == record_id)
    redcap_event_name_col <- which(colnames(df) == "redcap_event_name")
    record_repeat_inst_col <- which(colnames(df) == "redcap_repeat_instance")

    if (is_longitudinal) {
      # Select rows that have data with a repeat number
      if (is_repeated & !all(is.na(df[!allMissing, record_repeat_inst_col]))) {
        return(df[
          !allMissing,
          c(
            record_id_col,
            redcap_event_name_col,
            record_repeat_inst_col,
            first_col:last_col
          )
        ])
      } else {
        # Longitudinal not repeated instruments
        return(df[
          !allMissing,
          c(
            record_id_col,
            redcap_event_name_col,
            first_col:last_col
          )
        ])
      }
    } else {
      # Select rows that have data with a repeat number
      if (is_repeated & !all(is.na(df[!allMissing, record_repeat_inst_col]))) {
        return(df[
          !allMissing,
          c(
            record_id_col,
            record_repeat_inst_col,
            first_col:last_col
          )
        ])
      } else {
        return(df[
          !allMissing,
          c(
            record_id_col,
            first_col:last_col
          )
        ])
      }
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
    class(df[[i]]) <- classes2_ls[[i]]
  }

  return(df)
}
"fix_class_bug"


#' Drop the label from one or more variables
#' @description There is a reported issue with joins on data (without a reprex)
#' that seem to be caused by the labels. As a possible solution this can be
#' used to drop labels from one or more variables.
#'
#' @param df the name of the data frame
#' @param ... Variable selection using tidyselect helpers (e.g., contains(),
#' starts_with()) or column names as symbols or strings
#'
#' @examples
#' \dontrun{
#' # Remove labels from a single variable
#' df |> drop_label(employment)
#'
#' # Remove labels from multiple variables
#' df |> drop_label(employment, marital_status)
#'
#' # Remove all demograhic labels using tidyselect helpers
#' df |> drop_label(starts_with("dem_"))
#' }
#'
#' @export
#'
#' @return df with labels removed from selected variables
drop_label <- function(df, ...) {
  # Capture the variables using tidyselect
  vars_idx <- tidyselect::eval_select(rlang::expr(c(...)), df)

  # If no variables selected, return the dataframe as is
  if (length(vars_idx) == 0) return(df)

  # For each selected column, remove its attributes
  for (col_idx in vars_idx) {
    attributes(df[[col_idx]]) <- NULL
  }

  df
}
