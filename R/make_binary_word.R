#' Convert a choose all question into a binary word
#' 
#' @description This funciton takes a dataframe holding quesitons that correspond to a choose all that apply question in REDCap.  It can be used for any "binary word" problem.
#'
#' @param df The dataframe with the columns corresponding to 
#' @param yes_value A character string value that corresoonds to chooseing yes in a binary variable.  Defaults to the REDCap "Checked" option. 
#' @param the_labels A character vector holding letters for the word.  See the vignette called makeBinaryWord for an example.
#'
#' @return Character vector with length equal to the rows of `df`
#' 
#' @importFrom purrr map_chr
#' @importFrom stringr str_replace_na
#' @export
#'
#' @examples 
#'   test_df <- tibble::tibble(
#'     q1 = c("Unchecked", "Checked"),
#'     q2 = c("Unchecked", "Unchecked"),
#'     q3 = c("Checked", "Checked"),
#'     q4 = c("Checked", "Unchecked")
#'   )
#'   make_binary_word(test_df)
#'   
make_binary_word <- function(df, yes_value = "Checked", the_labels = letters) {
  
  # a matrix of true/false indicating if a choice was selected
  matrix_lgl <- as.matrix(df) == yes_value
  
  # vector corresponing to the answer element number (the third choose all thing is number 3)
  elementsOfPickAll <- seq_len(ncol(matrix_lgl))
  
  map_chr(
    .x = seq_len(nrow(matrix_lgl)),
    .f = ~ {
      chooseAllPatternPerRecord <- matrix_lgl[.x, ] * elementsOfPickAll
      chooseAllPatternPerRecord[chooseAllPatternPerRecord == 0] <- NA
      lettersAndNA <- the_labels[chooseAllPatternPerRecord]
      lettersAndUnderscore <- str_replace_na(lettersAndNA, replacement = "_")
      paste(lettersAndUnderscore, sep = "", collapse = "")
    }
  )
}