
#' Drop attributes/labels from variables or data frames
#' 
#' @description Some functions don't work with labelled variables. As a solution, 
#' this function can be used to drop labels (and all other attributes) from 
#' one or more variables within a data frame, from all variables if none are 
#' specified, or from a vector directly.
#'
#' @param x A data frame or a vector/column.
#' @param ... When `x` is a data frame, select variables using tidyselect 
#'   helpers (e.g., `contains()`, `starts_with()`) or unquoted names. 
#'   If empty, removes labels from ALL variables. Ignored when `x` is a vector.
#'
#' @return The modified data frame or vector with attributes removed.
#'
#' @examples
#' \dontrun{
#' # Dataset-level: Remove labels from ALL variables
#' df |> drop_label()
#'
#' # Dataset-level: Remove labels from specific variables
#' df |> drop_label(employment, starts_with("dem_"))
#'
#' # Variable-level: Use inside mutate
#' df |> mutate(name_first = drop_label(name_first))
#' 
#' # Variable-level: Use with across()
#' df |> mutate(across(c(age, income), drop_label))
#' }
#'
#' @export
drop_label <- function(x, ...) {
  # 1. Dataset-level logic
  if (is.data.frame(x)) {
    old_class_char <- class(x)
    
    # Check if any variables were selected
    vars_idx <- tidyselect::eval_select(rlang::expr(c(...)), x)
    
    # If no variables selected, process ALL columns
    if (length(vars_idx) == 0) {
      # seq_along will either capture the variable column number
      vars_idx <- seq_along(x)
    }
    
    # Remove attributes from selected columns
    for (col_idx in vars_idx) {
      # col_idx evaluates to:
      # 1. variable name(s) if passed with the `...` argument
      # 2. variable column position number if the whole dataset was passed for dropping

      # Get all current attributes
      col_attrs <- attributes(x[[col_idx]])

      # Remove the label attribute
      col_attrs$label <- NULL

      # Remove the "labelled" from class if it exists
      if (!is.null(col_attrs$class)) {
        col_attrs$class <- col_attrs$class[col_attrs$class != "labelled"]
        # If the class now becomes empty, remove it to use R's default
        if (length(col_attrs$class) == 0) col_attrs$class <- NULL
      }

      # Reapply the modified attributes
      attributes(x[[col_idx]]) <- col_attrs
    }
    
    # Preserve original class structure (data.frame vs tibble)
    if (("data.frame" %in% old_class_char) && !("tbl_df" %in% old_class_char)) {
      class(x) <- "data.frame"
    }
    
    return(x)
  }
  
  # 2. Variable-level logic
  if (is.character(substitute(x))) {
    stop('It looks like you quoted your variable. The variable must be unquoted when used inside mutate().')
  }

  attributes(x) <- NULL
  return(x)
}
