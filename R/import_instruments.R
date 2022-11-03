
#' @title Import all instruments into individual R tables
#' @description This function takes the url and key for a REDCap
#' project and returns a table for each instrument/form in the project.
#' @param url The API URL for your the instance of REDCap
#' @param token The API security token
#' @param drop_blank Drop records that have no data. TRUE by default.
#' @param record_id Name of `record_id` variable (if it was changed in REDCap).
#' @param envir The name of the environment where the tables should be saved.
#'
#' @return datasets, by default in the global environment
#'
#'
#' @importFrom REDCapR redcap_read redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr pull if_else
#' @importFrom magrittr %>%
#' @importFrom stringr str_remove
#' @importFrom tidyselect ends_with
#' @importFrom labelVector set_label
#' @importFrom cli cli_inform
#' @export
#'
#' @examples
#' \dontrun{
#' import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   Sys.getenv("test_API_key")
#' )
#' }
import_instruments <- function(url, token, drop_blank = TRUE,
                               record_id = "record_id",
                               envir = .GlobalEnv) {
  cli::cli_inform("Reading metadata about your project")
  #browser()
  ds_instrument <-
    suppressWarnings(
      suppressMessages(
        REDCapR::redcap_metadata_read(redcap_uri = url, token = token)$data
      )
    )

  # Get names of instruments
  form_name <- NULL

  instrument_name <- ds_instrument |>
    pull(form_name) |>
    unique()


  # do the api call
  # redcap <- redcapAPI::exportRecords(connection)
  cli::cli_inform("Reading variable labels for your variables")
  raw_labels <-
    suppressWarnings(
      suppressMessages(
          REDCapR::redcap_read(
            redcap_uri = url,
            token = token,
            raw_or_label_headers = "label",
            records = 1
          )$data
      )
    )

  just_labels <- raw_labels
  
  cli::cli_inform(c("Reading your data", i="This may take a while if your dataset is large."))
  raw_redcapr <-
    suppressWarnings(
      suppressMessages(
          REDCapR::redcap_read_oneshot(
            redcap_uri = url,
            token = token,
            raw_or_label = "label"
          )$data
      )
    )

  just_data <- raw_redcapr

  just_data[] <-
    mapply(
      nm = names(just_data),
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
      names(redcap) %in% paste0(instrument_name, "_complete")
    )

  # add placeholder
  bigI <- c(0, i)
  nInstr_int <- length(bigI) - 1

  is_longitudinal <- any(names(redcap) == "redcap_event_name")
  is_repeated <- any(names(df) == "redcap_repeat_instrument")

  if (is_longitudinal & is_repeated){
    meta <- c(1:4)
  } else if (is_repeated) {
    meta <- c(1:3)
  } else if (is_longitudinal) {
    meta <- c(1:2)
  } else {
    meta <- 1
  }
  
  
  
  
  #if (is_longitudinal) {
  #  meta <- c(1:2)
  #} else {
  #  meta <- 1
  #}

  # Load all datasets to the global environment
  for (dataSet in seq_len(nInstr_int)) {
    # all columns in the current instrument
    currInstr_idx <- (bigI[dataSet] + 1):bigI[dataSet + 1]

    drop_dot_one <- redcap[, c(meta, currInstr_idx)] %>%
      select(-ends_with(".1"))

    # drops blank instruments
    if (drop_blank == TRUE) {
      processed_blank <- make_instrument_auto(drop_dot_one, record_id = record_id)
    } else {
      processed_blank <- drop_dot_one
    }

    # The order of the names from exportInstruments() matches the order of the
    #   data sets from exportRecords()

    if (nrow(processed_blank > 0)) {
      assign(
        instrument_name[dataSet],
        processed_blank,
        envir = envir
      )
    } else {
      warning(
        paste("The", instrument_name[dataSet], "instrument/form has 0 records and will not be imported. \n"),
        call. = FALSE
      )
      # How to print warning about no records... how disruptive should this be?
    }
  }

  invisible()
}

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
#' @noRd
#' 
#' @return vector text changed
#'
#' @examples
#' \dontrun{
#' relabel("What ingredients do you currently crave? (choice=Chips)")
#' }
#'
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
