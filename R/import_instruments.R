#' @title Import all instruments into individual R tables
#' @description This function takes the url and key for a REDCap
#' project and returns a table for each instrument/form in the project.
#' @param url The API URL for your the instance of REDCap
#' @param token The API security token
#' @param drop_blank Drop records that have no data. TRUE by default.
#' @param record_id Name of `record_id` variable (if it was changed in REDCap).
#' @param first_record_id A value of the custom `record_id` variable (if
#'   changed in REDCap).  To improve the speed of the import, tidyREDCap pulls
#'   in a single record twice.  By default if uses the first record.  If you
#'   have a custom `record_id` variable and if its the first record identifier
#'   is not `1`,  specify a record identifier value here.  For example if you
#'   are using `dude_id` instead of `record_id` and `dude_id` has a value of
#'   "first dude" for one of its records this argument would be
#'   `first_record_id = "first dude"`.
#' @param envir The name of the environment where the tables should be saved.
#'
#' @return one `data.frame` for each instrument/form in a REDCap project. By
#'   default the datasets are saved into the global environment.
#'
#'
#' @importFrom REDCapR redcap_read redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr pull if_else
#' @importFrom magrittr %>%
#' @importFrom stringr str_remove str_remove_all fixed
#' @importFrom tidyselect ends_with
#' @importFrom labelVector set_label
#' @importFrom cli cli_inform
#' @importFrom keyring key_get
#' @export
#'
#' @examplesIf FALSE
#' import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   keyring::key_get("test_API_key")
#' )
import_instruments <- function(url, token, drop_blank = TRUE,
                               record_id = "record_id",
                               first_record_id = 1,
                               envir = .GlobalEnv) {
  
  cli::cli_inform("Looking for your project.... ")
  
  found_it <-
    suppressWarnings(
      suppressMessages(
        check_project_exists(url, token)
      )
    )

  if (!found_it) {
    cli::cli_abort(c(
      "I can't find the website.",
      "i" = "Make sure the url ends in \"redcap/api/\" and that your API token is still valid."
    ))
  }
  
  cli::cli_inform("Reading metadata about your project.... ")

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
  cli::cli_inform("Reading variable labels for your variables.... ")
  raw_labels <-
    suppressWarnings(
      suppressMessages(
        REDCapR::redcap_read(
          redcap_uri = url,
          token = token,
          raw_or_label_headers = "label",
          records = first_record_id
        )$data
      )
    )

  # Provide error for first instance of record id.
  if (dim(raw_labels)[1] == 0) {
    stop(
    "
    The first 'record_id' or custom id in df must be 1;
    use option 'first_record_id=' to set the first id in df.",
    call. = FALSE
    )
  }

  just_labels <- raw_labels

  # deal with nested parentheses
  # see https://stackoverflow.com/questions/74525811/how-can-i-remove-inner-parentheses-from-an-r-string/74525923#74525923
  just_labels_names <- names(just_labels) |>
    stringr::str_replace("(\\(.*)\\(", "\\1") |>
    stringr::str_replace("\\)(.*\\))", "\\1")

  cli::cli_inform(
    c(
      "Reading your data.... ",
      i = "This may take a while if your dataset is large."
    )
  )

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
      lab = relabel(just_labels_names),
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
  big_i <- c(0, i)
  n_instr_int <- length(big_i) - 1

  is_longitudinal <- any(names(redcap) == "redcap_event_name")
  is_repeated <- any(names(redcap) == "redcap_repeat_instrument")

  if (is_longitudinal && is_repeated) {
    meta <- c(1:4)
  } else if (is_repeated) {
    meta <- c(1:3)
  } else if (is_longitudinal) {
    meta <- c(1:2)
  } else {
    meta <- 1
  }

  # Load all datasets to the global environment
  for (data_set in seq_len(n_instr_int)) {
    # all columns in the current instrument
    curr_instr_idx <- (big_i[data_set] + 1):big_i[data_set + 1]
    
    column_index <-
      c(meta, curr_instr_idx) %>%
      # Sometimes the `record_id` can appear in both 
      # the metadata columns and the current instrument. 
      # See https://github.com/RaymondBalise/tidyREDCap/pull/61
      unique() 
      
    drop_dot_one <- redcap[, column_index] %>%
      select(-ends_with(".1"))

    # drops blank instruments
    if (drop_blank == TRUE) {
      processed_blank <-
        make_instrument_auto(drop_dot_one, record_id = record_id)
    } else {
      processed_blank <- drop_dot_one
    }

    # without this row names reflect the repeated instrument duplicates
    rownames(processed_blank) <- NULL

    # The order of the names from exportInstruments() matches the order of the
    #   data sets from exportRecords()

    if (nrow(processed_blank > 0)) {
      assign(
        instrument_name[data_set],
        processed_blank,
        envir = envir
      )
    } else {
      warning(
        paste(
          "The", instrument_name[data_set],
          "instrument/form has 0 records and will not be imported. \n"
        ),
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
#' @examplesIf FALSE
#' relabel("What ingredients do you currently crave? (choice=Chips)")
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

#' check_project_exists
#'
#' @description This checks to make sure that the user specified a valid project
#'
#' @param redcap_uri the REDCap URL
#' @param token the API key
#'
#' @returns logical
#' 
#' @importFrom REDCapR redcap_project_info_read 
#' 
#' @export
check_project_exists <- function(redcap_uri, token) {
  result <- REDCapR::redcap_project_info_read(
    redcap_uri = redcap_uri,
    token      = token,
    verbose    = FALSE
  )
  result$success
}
