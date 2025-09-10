#' @title make_yes_no
#'
#' @description Convert a "Yes-No", "True-False", or "Checkboxes (Multiple
#'     Answers)" question in REDCap to a factor holding "Yes" or
#'     "No or Unknown". Technically "yes" or "checked" (ignoring case), 1 or
#'     TRUE responses are converted to "Yes" and all other values to
#'     "No or Unknown". Also see `make_yes_no_unknown()`.
#'
#' @param x x variable to be converted to hold "Yes" or "No or Unknown"
#'
#' @return a factor with "Yes" or "No or Unknown"
#'
#' @importFrom stringr str_detect regex
#' @importFrom dplyr case_when
#' @importFrom labelled var_label
#'
#' @export
#'
#' @examples
#' make_yes_no(c(0, 1, NA))
#' make_yes_no(c("unchecked", "Checked", NA))
make_yes_no <- function(x) {
  # Store original label
  original_label <- var_label(x)
  
  if (is.factor(x) | is.character(x)) {
    result <- factor(
      case_when(
        str_detect(
          x, stringr::regex("^yes", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        str_detect(
          x, stringr::regex("^checked", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        TRUE ~ "No or Unknown" # Note: this will catch Y or y with an accent
      ),
      levels = c("No or Unknown", "Yes")
    )
  } else if (is.numeric(x) | is.logical(x)) {
    result <- factor(
      case_when(
        x == 1 ~ "Yes",
        x == 0 ~ "No or Unknown",
        TRUE ~ "No or Unknown"
      ),
      levels = c("No or Unknown", "Yes")
    )
  } else {
    result <- x # not an expected atomic class
  }
  
  # Restore original label if it existed
  if (!is.null(original_label)) {
    var_label(result) <- original_label
  }
  
  result
}
