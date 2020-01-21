#' Get a Variable Label from a Data Set and Variable 
#'
#' @param data The name of the data set
#' @param aVariable The name of the variable
#' 
#' @importFrom stringr str_sub str_locate
#'
#' @return A variable's response label without  the choose all the question
#'
## @examples
getLabel2 <- function(data, aVariable) {
  # pull the variable out and into a data frame
  variable <- {{ data }}[aVariable]
  
  # grab the label attribute off the variable inside of the DF
  theLab <- dropTags(attributes(variable[, aVariable])$label)
  stringr::str_sub(theLab, stringr::str_locate(theLab, ":")[, 1] + 2, nchar(theLab))
}


#' Count The Reponses to a Choose All That Apply Question 
#'
#' @param df The name of the data set
#' @param variable The name of the REDCap variable
#' 
#' @importFrom dplyr select starts_with mutate_all mutate_if summarise_all
#' @importFrom dplyr mutate pull rename bind_cols
#' @importFrom tidyr pivot_longer
#' @importFrom purrr map_chr
#' @importFrom tibble enframe
#' @importFrom rlang .data
#' @export
#'
#' @return A variable's response label without  the choose all the question
#'
## @examples make_choose_all_table(redcap, "ingredients")
make_choose_all_table <- function(df, variable) {
  # . <- NULL # kludge to get CMD Check to pass with nonstandard evaulation
  counts <- df %>%
    dplyr::select(dplyr::starts_with(variable)) %>%
    dplyr::mutate_all(~ . == "Checked") %>%
    dplyr::mutate_if(is.logical, as.numeric) %>%
    dplyr::summarise_all(sum) %>%
    dplyr::mutate(blah = "x") %>%
    tidyr::pivot_longer(-.data$blah, names_to = "thingy", values_to = "Count") 
  
  aTable <- 
    counts %>%
    dplyr::pull(.data$thingy) %>%
    purrr::map_chr(.f = ~ {
      getLabel2(df, .x)
    }) %>%
    tibble::enframe(name = NULL) %>%  # new variable is value
    dplyr::rename("What" = .data$value) %>% 
    dplyr::bind_cols(.data$., counts) %>% 
    dplyr::select(.data$What, .data$Count)
  aTable
}


