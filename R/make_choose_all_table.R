#' Get a variable's label from a data frame and variable
#' @param data The name of the data set
#' @param aVariable The name of the variable
#' @importFrom stringr str_sub str_locate
#' @importFrom labelVector get_label
#' @return A variable's response label without the repeated text from of a
#'     _choose all that apply_ question
#'
#' @noRd
#'
## @examples
getLabel2 <- function(data, aVariable) {
  
  #browser()
  # pull the variable out and into a data frame
  variable <- {{ data }}[aVariable]
  
  # grab the label attribute off the variable inside of the DF
  #theLab <- dropTags(attributes(variable[, aVariable])$label)
  theLab <- dropTags(labelVector::get_label(variable[, aVariable]))
  
  
  # check for the delimiters to mark the label for the answer
  # the manual export uses = or from the api uses : 
  
  if (stringr::str_detect(theLab, ":") & stringr::str_detect(theLab, "=")){
    stop("I am confused because I see both ':' and '=' characters in a label")
  } else if (stringr::str_detect(theLab, ":")) {
    stringr::str_sub(
      # note: + 2 for extra space after `: `
      theLab, stringr::str_locate(theLab, ":")[, 1] + 2,
      nchar(theLab)
    )
  } else if (stringr::str_detect(theLab, "=")){
    stringr::str_sub(
      # note: + 1 for `=text` with no space
      theLab, stringr::str_locate(theLab, "=")[, 1] + 1,
      nchar(theLab)-1
    )
  }
  
}


#' Count The Responses to a Choose All That Apply Question
#'
#' @description This will tally the number of responses on a choose all that 
#'   apply question.  This function extracts the option name from the variable
#'   labels.  So the data set needs to be labeled.  See 
#'   the [Make a 'Choose All' Table](../doc/makeChooseAllTable.html) vignette 
#'   for help.
#'
#' @param df The name of the data set (it needs labels)
#' @param variable The name of the REDCap variable
#'
#' @importFrom dplyr select starts_with summarise_all 
#' @importFrom dplyr across mutate pull rename bind_cols
#' @importFrom tidyr pivot_longer
#' @importFrom purrr map_chr map_lgl
#' @importFrom tibble enframe
#' @importFrom tidyselect everything vars_select_helpers starts_with
#' @importFrom rlang .data
#' @importFrom labelVector is_labelled
#' @export
#'
#' @return A variable's response label without  the choose all the question
#'
## @examples
## \dontrun{
##  make_choose_all_table(redcap, "ingredients")
##  }
make_choose_all_table <- function(df, variable) {
  # . <- NULL # kludge to get CMD Check to pass with nonstandard evaluation
  the_vars_df <- df %>%
    dplyr::select(dplyr::starts_with(variable))
  
  are_vars_labelled <- purrr::map_lgl(the_vars_df, labelVector::is_labelled)
  
  
  if (! all(are_vars_labelled)) {
    stop(
      paste0(
        "The variables must be labeled. \n",
        "Try exporting your data from REDCap with the make_instruments() ",
        "function.")
      , call. = FALSE)
    
  }
  
  # fix no visible bindings for global variables in CRAN check
  blah <- NULL
  value <- NULL
  What <- NULL
  Count <- NULL
  
  counts <- the_vars_df |> 
    dplyr::mutate(dplyr::across(tidyselect::everything(), ~ . %in% c("1", "Checked"))) %>%
    dplyr::mutate(dplyr::across(
      tidyselect::vars_select_helpers$where(
        is.logical
      ),
      as.numeric
    )) %>%
    dplyr::summarise(across(everything(), ~ sum(.x, na.rm = TRUE))) %>%
    dplyr::mutate(blah = "x") %>%
    tidyr::pivot_longer(-`blah`, names_to = "thingy", values_to = "Count")
  
  aTable <-
    counts %>%
    dplyr::pull(.data$thingy) %>%
    purrr::map_chr(.f = ~ {
      getLabel2(df, .x)
    }) %>%
    tibble::enframe(name = NULL) %>% # new variable is value
    dplyr::rename("What" = `value`) %>%
    dplyr::bind_cols(counts) %>%
    dplyr::select(`What`, `Count`)
  aTable
}
