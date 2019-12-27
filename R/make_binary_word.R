#' Convert a choose all question into a binary word
#' 
#' @description Pass in a set variable
#'
#' @param df the dataframe with the columns 
#' @param yes_value what was checked
#' @param the_labels character vector for indicator letters 
#'
#' @return character vector of length of rows of `df`
#' 
#' @importFrom purrr map_chr
#' @importFrom stringr str_replace_na
#' @export
#'
#' @example NULL
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