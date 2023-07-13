#' @title make_yes_no_unknown
#'
#' @description Convert a "Yes-No", "True-False" or "Checkboxes (Multiple 
#'     Answers)" question in REDCap to a factor holding "No" or
#'     "Yes" or "Unknown". Technically "yes" or "checked" (ignoring case), 1 or 
#'     TRUE responses are converted to "Yes". "No" or "unchecked" (ignoring 
#'     case), 0 or FALSE are converted to "No".  All other values are set to
#'     "Unknown". Also see `make_yes_no()`.
#'
#' @param x variable to be converted to hold "No", "Yes", or "Unknown"
#'
#' @return a factor with "No", "Yes", or "Unknown"
#' 
#' @importFrom stringr str_detect regex
#' @importFrom dplyr case_when
#' 
#' @export
#'
#' @examples
#' make_yes_no_unknown(c(0, 1, NA))
#' make_yes_no_unknown(c("unchecked", "Checked", NA))
make_yes_no_unknown <- function(x) {
  if(is.factor(x) | is.character(x)){
    factor(
      dplyr::case_when(
        str_detect(
          x, stringr::regex("^yes", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        str_detect(
          x, stringr::regex("^checked", ignore_case = TRUE)
        ) == TRUE ~ "Yes",
        str_detect(
          x, stringr::regex("^no", ignore_case = TRUE)
        ) == TRUE ~ "No",
        str_detect(
          x, stringr::regex("^unchecked", ignore_case = TRUE)
        ) == TRUE ~ "No",
        TRUE ~ "Unknown"
      ),
      levels = c("No", "Yes", "Unknown")
    )
  } else if (is.numeric(x) | is.logical(x)) {
    factor(
      dplyr::case_when(
        x == 1 ~ "Yes",
        x == 0 ~ "No",
        TRUE ~ "Unknown"
      ),
      levels = c("No", "Yes", "Unknown")
    )
    
  } else {
    x
  } 
}
