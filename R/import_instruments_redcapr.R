
#' @title relabel
#' 
#' @description This is a function to change labels to match REDCapAPI. REDCapR
#' labels "choose all that apply" variables with "(choice= thingy)" vs. 
#' ": thingy" in REDCapAPI.
#'
#' @param x Character string variable holding label to be check for possible 
#' labels that need fixing to match REDCapAPI's variable label convention.
#'
#' @importFrom stringr str_count str_sub str_extract
#'
#' @return vector text changed
#' 
#' @examples
#'\dontrun{
#' relabel("What ingredients do you currently crave? (choice=Chips)")
#'}

relabel <- function(x) {
  # regular expression (Reg Ex) to get content inside () after choice=
  re <- "\\(choice=([^()]+)\\)" 
  if_else(
    stringr::str_count(x, "\\(choice") == 0,
    x,
    paste0(
      stringr::str_sub(x, 1, str_locate(x, "\\(choice")[, 1] - 2),
      ": ",
      gsub(re, "\\1", stringr::str_extract(x, re)) # content inside of Reg Ex
    )
  )
}


#' import_instruments_redcapr
#' 
#' @description This function takes the url and key for a REDCap
#' project and returns a table for each instrument/form in the project. 
#'
#' @param url The API URL for your the instance of REDCap
#' @param token The API security token
#' @param drop_blank Drop records that have no data. TRUE by default.
#' @param envir The name of the environment where the tables should be saved.
#'
#' @return datasets, by default in the global environment
#' 
#' 
#' @importFrom REDCapR redcap_read
#' @importFrom dplyr pull if_else
#' @importFrom magrittr %>%
#' @importFrom stringr str_which str_remove
#' @importFrom tidyselect ends_with
#' @importFrom labelVector set_label
#' @export
#'
#' @examples
#'\dontrun{
#'  import_instruments_redcapr(
#'     "https://redcap.miami.edu/api/", 
#'     Sys.getenv("test_API_key")
#'  )
#'}   
import_instruments_redcapr <- function(url, token, drop_blank = TRUE, envir = .GlobalEnv) {
  #browser()
  
  ds_instrument <- 
    REDCapR::redcap_metadata_read(redcap_uri=url, token=token)$data
  
  # Get names of instruments
  form_name <- NULL
  
  instrument_name <- ds_instrument |> 
    pull(form_name) |> 
    unique() 

  
  # do the api call
  #redcap <- redcapAPI::exportRecords(connection)
  
  raw_labels <- 
    REDCapR::redcap_read(
      redcap_uri = url, 
      token = token,
      raw_or_label_headers = "label",
      records = 1
    )$data
  
  just_labels <- raw_labels

  raw_redcapr <- 
    REDCapR::redcap_read(
      redcap_uri = url, 
      token = token,
    )$data
  
  just_data <- raw_redcapr
  
  just_data[] <- 
    mapply(nm = names(just_data),
           lab = relabel(names(just_labels)),
           FUN = function(nm, lab) {
             labelVector::set_label(just_data[[nm]], lab)
           }, 
           SIMPLIFY = FALSE
    )
  
  redcap <- just_data
  
  
  
  
  
  
  # get the index (end) of instruments
  i <- 
    which(
      str_remove(names(redcap), "_complete") %in% instrument_name
    )
  
  # add placeholder
  bigI <- c(0, i)
  nInstr_int <- length(bigI) - 1
  
  is_longitudinal <- any(names(redcap) == "redcap_event_name")
  
  if(is_longitudinal){
    meta=c(1:2)
  } else {
    meta=1
  }
  
  # Load all datasets to the global environment
  for(dataSet in seq_len(nInstr_int)) {
    
    # all columns in the current instrument
    currInstr_idx <- (bigI[dataSet] + 1):bigI[dataSet + 1]
   
    drop_dot_one <- redcap[, c(meta,currInstr_idx)]  %>%       
      select(-ends_with(".1"))
    
    # drops blank instruments
    if(drop_blank == TRUE){
      processed_blank <- make_instrument_auto(drop_dot_one)
    } else {
      processed_blank <- drop_dot_one
    }
    
    # The order of the names from exportInstruments() matches the order of the
    #   data sets from exportRecords()
    
    if(nrow(processed_blank > 0)){
      assign(
        instrument_name[dataSet],
        processed_blank,
        envir = envir
      )
    } else{
      # How to print warning about no records... how disruptive should this be?
    }
  }
  
  invisible()
}