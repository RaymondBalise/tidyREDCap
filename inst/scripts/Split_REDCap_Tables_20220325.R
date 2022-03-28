library(tidyREDCap)
library(redcapAPI)
library(tidyverse)


#' Title
#' 
#' @description 
#'
#' @param connection 
#' @param envir 
#'
#' @return
#' 
#' @details 
#' 
#' @importFrom redcapAPI exportInstruments exportRecords
#' @importFrom dplyr pull
#' @importFrom magrittr %>%
#' @importFrom stringr str_which
#' @export
#'
#' @examples
#'   rcon <- redcapAPI::redcapConnection(
#'     url <- "https://redcap.miami.edu/api/",
#'     token = Sys.getenv("REDCAP_PLACEHOLDER5_KEY")
#'   )
#'   
#'   import_instruments(rcon)
#'   
import_instruments <- function(connection, envir = .GlobalEnv) {
  # browser()

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
  
  # Load all datasets to the global environment
  for(dataSet in seq_len(nInstr_int)) {
  	
  	# all columns in the current instrument
  	currInstr_idx <- (bigI[dataSet] + 1):bigI[dataSet + 1]
  	# The order of the names from exportInstruments() matches the order of the
  	#   data sets from exportRecords()
  	assign(
  		data_name[dataSet],
  		redcap[, c(1:2,currInstr_idx)] %>% 
   # Dropping duplicate record_id and event_name from first instrument
  		select_if(!names(.) %in% c("record_id.1", "redcap_event_name.1")),
  		envir = envir
  	)
  	
  }

  invisible()
}

# Test
rcon <- redcapAPI::redcapConnection(
	url <- "https://redcap.miami.edu/api/",
	token = Sys.getenv("REDCAP_PLACEHOLDER5_KEY")
)
import_instruments(rcon)