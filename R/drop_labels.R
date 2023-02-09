#' Drop all the labels from a variable
#' @description There is an issue with the function we are using to add column 
#'   labels.  If you run into problems processing the labels.
#'
#' @param df The data frame with column labels that you want to drop
#'
#' @export
#' 
#' @return df without column labels
#' 
#' @examples 
#' \dontrun{
#' demographics |>
#'   drop_labels() |>
#'   skimr::skim()
#' }
drop_labels <- function(df) {
  lapply(df, function(x) { attributes(x) <- NULL; x }) 
}