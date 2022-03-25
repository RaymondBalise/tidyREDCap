# Strip REDCap Labels from Data Columns
# Wayne D., Gabriel O., and Ray B.
# 2022-03-25


###  Example Data  ###
redcap <- structure(
  list(
    record_id = structure(
      c("1", "2", "3"),
      label = "Record ID",
      class = c("labelled", "character")
    ),
    dsq_xx1_age = structure(
      c(45, 34, 57),
      label = "<div class=\"rich-text-field-label\"><p><span style=\"font-weight: normal;\">How old are you (in years)?</span></p></div>",
      class = c("labelled", "numeric")
    ),
    dsq_complete = structure(c(1L, 1L, 1L),
      .Label = c("Incomplete", "Unverified", "Complete"),
      class = c("redcapFactor", "factor"),
      redcapLabels = c("Incomplete", "Unverified", "Complete"),
      redcapLevels = 0:2
    )
  ),
  row.names = c(NA, -3L),
  class = "data.frame"
)

library(tidyverse)
library(rvest)
library(xml2)
library(haven)
library(labelled)


###  The Function  ###
strip_redcap_html <- function(redcapColumn) {
	
  call_char <- as.character(match.call())
  label_char <- redcapColumn %>%
  	attributes() %>%
  	unlist() %>%
  	purrr::pluck("label")
  
  
  if (is.null(label_char)) {
  	# A column with no label
  	
  	if (str_detect(call_char[2], "(?:\\$)")) {
  		str_extract(call_char[2], "(?<=\\$).*")
  	} else {
  		call_char[2]
  	}
  	
  } else if (stringr::str_detect(label_char, "<div")) {
  	# A column with HTML code in the label
  	
  	label_char %>%
  		purrr::simplify() %>%
  		xml2::read_xml() %>%
  		rvest::html_text()
  	
  } else {
  	# All other labelled columns
  	label_char
  }
}

# Test
strip_redcap_html(redcap$dsq_xx1_age)
strip_redcap_html(redcap$record_id)
strip_redcap_html(redcap$dsq_complete)


###  Apply the Function  ###
fix_label <- function(the_data) {
  output <- the_data %>%
    summarise(across(everything(), ~ strip_redcap_html(.)))

  t <- redcap %>%
    zap_label()

  t1 <- output %>%
    pivot_longer(everything(), names_to = "variable", values_to = "label") %>%
    pluck("label")

  labelled::set_variable_labels(t, .labels = t1)
}

blah <- fix_label(redcap)
