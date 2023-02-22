#' @title make_yes_no
#'
#' @description Convert a "Yes-No", "True-False" or "Checkboxes (Multiple 
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
#' 
#' @export
#'
#' @examples 
#' make_yes_no(c(0, 1, NA))
#' make_yes_no(c("unchecked", "Checked", NA))

make_yes_no <- function(x) {
  if(is.factor(x) | is.character(x)){
    factor(
      case_when(
        str_detect(
          x, stringr::regex("^yes", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        str_detect(
          x, stringr::regex("^checked", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        TRUE ~ "No or Unknown"
      ),
      levels = c("No or Unknown", "Yes")
    )
  } else if (is.numeric(x) | is.logical(x)) {
    factor(
      case_when(
        x == 1 ~ "Yes",
        x == 0 ~ "No or Unknown",
        TRUE ~ "No or Unknown"
      ),
      levels = c("No or Unknown", "Yes")
    )
    
  } else {
    x
  } 
}
