#' import_instruments
#' 
#' @description This function takes the name of a connection to a REDCap
#' project and returns a table for each instrument/form in the project. 
#'
#' @param connection The name of connection created by a call to the
#'   `redcapAPI::redcapConnection()` function
#' @param drop_blank Drop records that have no data. TRUE by default.
#' @param envir The name of the environment where the tables should be saved.
#'
#' @return datasets, by default in the global environment
#' 
#' 
#' @importFrom redcapAPI exportInstruments exportRecords
#' @importFrom dplyr pull
#' @importFrom magrittr %>%
#' @importFrom stringr str_which
#' @importFrom tidyselect ends_with
#' @export
#'
#' @examples
#'\dontrun{
#'   rcon <- redcapAPI::redcapConnection(
#'     url <- "https://redcap.miami.edu/api/",
#'     token = Sys.getenv("REDCAP_PLACEHOLDER5_KEY")
#'   )
#'   
#'   import_instruments(rcon)
#'}   
import_instruments <- function(connection, drop_blank = TRUE, envir = .GlobalEnv) {
   #browser()
  
  if(class(connection) != "redcapApiConnection"){
    stop("The `connection` argument must come from `redcapAPI::redcapConnection()`. See the `Using the imports_instruments() function` vignette.", call. = FALSE)
  }

  # Get names of instruments
  instrument_name <- NULL
  data_name <- redcapAPI::exportInstruments(connection) %>%
    pull(instrument_name)
  
  # do the api call
  redcap <- redcapAPI::exportRecords(connection)
  
  # get the index (end) of instruments
  i <- redcap %>%
    names() %>%
    str_which("_complete")
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
    assign(
      data_name[dataSet],
      processed_blank,
      envir = envir
    )
    
  }
  
  invisible()
}