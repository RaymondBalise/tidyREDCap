#' Find a variable in a dataset
#' 
#' @param var_name Character or length one. The quoted variable to find in the Global
#'   Environment.
#' 
#' @description When using tidyREDCap projects, a variable may appear in multiple
#'   datasets. This allows users to easily find which dataset(s) a variable name is in 
#'   from the Global Environment. 
#' 
#' @examples
#' find_variable('record_id')
find_variable <- function(var_name) {
  # Get all objects in the environment
  all_objects <- ls(envir = .GlobalEnv)

  # Create a vector to store results
  found_in <- character(0)

  # Loop through objects and check their names
  for (obj_name in all_objects) {
    # Skip the function itself
    if (obj_name == "find_variable") {
      next
    }

    # Get the object
    obj <- get(obj_name, envir = .GlobalEnv)

    # Check if it's a data frame and contains the variable
    if (is.data.frame(obj) && var_name %in% names(obj)) {
      found_in <- c(found_in, obj_name)
    }
  }

  # Return results
  if (length(found_in) == 0) {
    return(paste0("Variable '", var_name, "' not found in any dataset"))
  } else {
    return(found_in)
  }
}
"find_variable"