#' dropTags
#' 
#' @description Cuts html tags from a variable. Used to clean labels
#'
#' @param x a string
#'
#' @return a string
dropTags <- function(x) {
  return(gsub("<.*?>", "", x))
}


#' taybull function
#'
#' @description Make a labeled janitor table from a single variable 
#'
#' @param variable a factor to report on 
#' @param subset parse off extra variable if used with a choose all question
#' 
#' @importFrom stringr str_locate str_sub
#' @importFrom janitor adorn_pct_formatting tabyl
#'
#' @return a table
taybull <- function(variable, subset = FALSE) {
  
  # grab the label attribute off the variable
  theLab <- attr(variable, "label") %>% 
    dropTags() 
  
  # print the label
  if (subset == FALSE) {
    cat(paste(theLab, "\n"))
  } else {
    # cut the repeated parts off choose all that apply
    theLab2 <- stringr::str_sub(theLab, 
                                stringr::str_locate(theLab, ":")[, 1] + 2, 
                                nchar(theLab))
    cat(paste(theLab2, "\n"))
  }
  Response <- variable
  janitor::tabyl(Response) %>% 
    janitor::adorn_pct_formatting(digits = 0)
}


#' taybull2
#'
#' @description Make a labeled janitor table from a dataset and variable 
#'
#' @param data a dataframe that has the factor to report on 
#' @param aVariable a factor to report on 
#' @param subset parse off extra variable name if used with a choose all 
#'     question
#'     
#' @importFrom dplyr pull     
#'
#' @return a table
taybull2 <- function(data, aVariable, subset = FALSE) {
  # pull the variable out and into a data frame
  Response <- data %>% 
    dplyr::pull({{aVariable}})
  
  # grab the label attribute off the variable inside of the DF
  theLab <- dropTags(attributes(Response)$label)
  
  # print the label
  if(subset == FALSE){ 
    cat(paste(theLab, "\n"))
  } else {
    # cut the repeated parts off choose all that apply
    theLab2 <- stringr::str_sub(theLab, 
                                stringr::str_locate(theLab, ":")[,1]+2, 
                                nchar(theLab))
    cat(paste(theLab2, "\n"))
  }
  
  janitor::tabyl(Response) %>% 
    janitor::adorn_pct_formatting(digits = 0) 
}

#' make_choose_one_table
#' 
#' @description Pass this function either a labeled factor or a data frame and
#' a factor in the fame and it will return a janitor style table.  Use subset =
#' TRUE if you are making a report on varaible that is part of a choose all that
#' apply question.
#'
#' @param arg1 data frame that has a factor or a factor name
#' @param arg2 if arg1 is a data frame this is the factor name
#' @param subset TRUE/FALSE Remove extra variable name text from the label if used with a 
#'     choose all question
#'
#' @return a table
#' @export
make_choose_one_table <- function(arg1, arg2, subset = FALSE){
  if (is.factor(arg1)){
    return(taybull(arg1, subset))
  } else if (is.data.frame(arg1)){
    return(taybull2(arg1, {{arg2}}, subset))
  }
}