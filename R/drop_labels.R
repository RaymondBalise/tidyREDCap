#' Drop all the labels from a variable
#' @description There is an issue with the function we are using to add column 
#'   labels.  If you run into problems processing the labels.
#'
#' @param df The data frame with column labels that you want to drop
#' 
#' @importFrom purrr map_df
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
  # browser()
  old_class_char <- class(df)
  if (!("data.frame" %in% old_class_char)) {
    stop("df must have class data.frame", call. = FALSE)
  }
  out <- map_df(
    .x = df,
    .f = function(x) { attributes(x) <- NULL; x }
  ) 
  # out2 <- lapply(
  #   X = df,
  #   FUN = function(x) { attributes(x) <- NULL; x }
  # ) |>
  #   data.frame()
  if(("data.frame" %in% class(out)) & !("tbl_df" %in% old_class_char)) {
    # If we got a base data frame originally, return a base data frame
    class(out) <- "data.frame"
  } else if ("data.frame" %in% old_class_char & is.atomic(out)) {
    # If we originally had a tibble, the output would still be a tibble and not
    #   an atomic vector; this will catch base tibbles with 1 column (we hope)
    out_atomic <- out
    out_name_char <- names(out_atomic)
    out <- data.frame(out)
    colnames(out) <- out_name_char
  } else {
    # It is a tibble; do nothing
  }
  out

}