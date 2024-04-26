library(tidyverse)

# load raw data
tidyREDCap::import_instruments(
  "https://redcap.miami.edu/api/",
  Sys.getenv("icecream")
)

# backup to avoid repeated API calls
raw <- ice_cream_questionnaire
ice_cream_questionnaire <- raw

#' @title replace_checked
#'
#' @description
#' This replaces "Checked" word the choice from a check box.
#' 
#' @param thing A labelled variable holding check box response. 
#'
#' @noRd
#'
#' @return vector
#'
#' @examples
replace_checked <- function(thing) {
  if_else(
    thing == "Checked",
    getLabel1(thing),
    "Unchecked"
  )
}  

#' @title getLabel1
#'
#' @description
#' Pass this function a labelled variable and it returns the label from a 
#' checkbox entry.  It drops the _variable name_: from the label. This is 
#' related to getLabel2 (which was done first). 
#' 
#' @param aVariable 
#'
#' @noRd
#'
#' @return
#'
#' @examples
getLabel1 <- function(aVariable) {
  
  # grab the label attribute off the variable inside of the DF
  theLab <- tidyREDCap:::dropTags(attributes(aVariable)$label)
  
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



#' @title process_boxes
#'
#' @description
#' Pass this function a dataset and the "stem" of a checkbox variable's name 
#' (i.e., the part before the ___#. It will return a long skinny table with the 
#' checkbox responses in a single column.
#' 
#'
#' @param data The name of a dataset with labels
#' @param check_boxes The name of the checkbox variables before the ___ number.
#'
#'
#' @return A tibble
#' @export
#'
#' @examples
#' \dontrun{
#' ice_cream_questionnaire |> 
#    process_boxes("toppings")
#' }

process_boxes <- function(data, check_boxes) {
  data |> 
    mutate(across(starts_with(check_boxes), replace_checked)) |> 
    tidyREDCap::drop_labels() |> 
    pivot_longer(
      cols = starts_with(check_boxes),
      names_to = "thing",
      values_to = "checked_unchecked"
    ) |> 
    filter(checked_unchecked != "Unchecked") |> 
    select(-thing) |> 
    rename({{check_boxes}} := checked_unchecked)  
}

totals <-
  ice_cream_questionnaire |> 
  process_boxes("toppings")

totals |> 
  group_by(flavor, age_group) |> 
  count(toppings)

