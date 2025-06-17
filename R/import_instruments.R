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
#' @param return_list If TRUE, returns a named list. If FALSE (default), assigns to environment.
#' @param filter_instrument Optional character string specifying which instrument
#'   to use for filtering. If provided with filter_table, this instrument will be
#'   filtered first, and the resulting record IDs will be used to filter all
#'   other instruments.
#' @param filter_table Optional function that takes a tbl object and returns
#'   a modified tbl object. If filter_instrument is specified, this filter is
#'   applied only to that instrument, and resulting record IDs filter all others.
#'   If filter_instrument is NULL, filter applies to each instrument separately.
#'   Example: \code{function(x) x |> filter(age >= 18)}
#'
#' @return one `data.frame` for each instrument/form in a REDCap project. If
#'   assigned to a variable or return_list=TRUE, returns a named list. Otherwise,
#'   datasets are saved into the specified environment.
#'
#' @importFrom REDCapR redcap_read redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr pull if_else collect tbl select all_of filter distinct sym
#' @importFrom stringr str_remove str_remove_all fixed str_replace str_count str_sub str_extract str_locate
#' @importFrom tidyselect ends_with
#' @importFrom labelVector set_label
#' @importFrom cli cli_inform
#' @importFrom redquack redcap_to_db
#' @importFrom DBI dbConnect dbDisconnect dbWriteTable dbRemoveTable dbExistsTable
#' @importFrom duckdb duckdb
#' @importFrom rlang !!
#' @export
#'
#' @examples
#' \dontrun{
#' # Import each instrument to multiple tables
#' import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   Sys.getenv("test_API_key")
#' )
#'
#' # Import each instrument to a single list
#' instruments <- import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   Sys.getenv("test_API_key")
#' )
#'
#' # Filter all instruments based on demographics
#' instruments <- import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   Sys.getenv("test_API_key"),
#'   filter_instrument = "demographics",
#'   filter_table = \(x) x |> filter(age >= 18)
#' )
#' }
import_instruments <- function(url, token, drop_blank = TRUE,
                               record_id = "record_id",
                               first_record_id = 1,
                               envir = .GlobalEnv,
                               return_list = FALSE,
                               filter_instrument = NULL,
                               filter_table = NULL) {
  # internal function to extract instrument data
  extract_instrument_data <- function(data_set, big_i, meta, just_data) {
    curr_instr_idx <- (big_i[data_set] + 1):big_i[data_set + 1]
    column_index <- c(meta, curr_instr_idx) |> unique()
    just_data[, column_index] |> select(-ends_with(".1"))
  }

  # internal function to apply filters
  apply_instrument_filter <- function(drop_dot_one, filtered_ids, filter_table,
                                      duckdb, data_set, record_id, for_env = FALSE) {
    if (!is.null(filtered_ids)) {
      return(drop_dot_one |> filter(!!sym(record_id) %in% filtered_ids))
    }

    if (!is.null(filter_table)) {
      suffix <- if (for_env) "_env" else ""
      temp_table_name <- paste0("instrument", suffix, "_", data_set)
      dbWriteTable(duckdb, temp_table_name, drop_dot_one, overwrite = TRUE)

      filtered_data <- tbl(duckdb, temp_table_name) |>
        filter_table() |>
        collect()

      # preserve labels
      for (col_name in names(filtered_data)) {
        if (col_name %in% names(drop_dot_one)) {
          attr(filtered_data[[col_name]], "label") <- attr(drop_dot_one[[col_name]], "label")
        }
      }

      if (dbExistsTable(duckdb, temp_table_name)) {
        dbRemoveTable(duckdb, temp_table_name)
      }

      return(filtered_data)
    }

    drop_dot_one
  }

  # internal function to process instrument
  process_instrument <- function(instrument_data, drop_blank, record_id) {
    processed <- if (drop_blank) {
      make_instrument_auto(instrument_data, record_id = record_id)
    } else {
      instrument_data
    }
    rownames(processed) <- NULL
    processed
  }

  cli_inform("Reading metadata about your project.... ")

  ds_instrument <-
    suppressWarnings(
      suppressMessages(
        redcap_metadata_read(redcap_uri = url, token = token)$data
      )
    )

  # get names of instruments
  form_name <- NULL
  instrument_name <- ds_instrument |>
    pull(form_name) |>
    unique()

  # validate filter_instrument if provided
  if (!is.null(filter_instrument) && !filter_instrument %in% instrument_name) {
    stop("filter_instrument '", filter_instrument, "' not found in project instruments: ",
      paste(instrument_name, collapse = ", "),
      call. = FALSE
    )
  }

  cli_inform("Reading variable labels for your variables.... ")
  raw_labels <-
    suppressWarnings(
      suppressMessages(
        redcap_read(
          redcap_uri = url,
          token = token,
          raw_or_label_headers = "label",
          records = first_record_id
        )$data
      )
    )

  # provide error for first instance of record id
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
  just_labels_names <- names(just_labels) |>
    str_replace("(\\(.*)\\(", "\\1") |>
    str_replace("\\)(.*\\))", "\\1")

  cli_inform(c("Reading your data.... "))

  # create temporary DuckDB connection
  db_file <- tempfile(fileext = ".duckdb")
  duckdb <- dbConnect(duckdb(), db_file)

  on.exit({
    dbDisconnect(duckdb)
    if (file.exists(db_file)) file.remove(db_file)
  })

  # import REDCap data to DuckDB
  duckdb_result <- redcap_to_db(
    conn = duckdb,
    redcap_uri = url,
    token = token,
    record_id_name = record_id,
    beep = FALSE
  )

  just_data <- tbl(duckdb, "data") |> collect()

  # apply labels
  just_data[] <-
    mapply(
      nm = names(just_data),
      lab = relabel(just_labels_names),
      FUN = function(nm, lab) {
        set_label(just_data[[nm]], lab)
      },
      SIMPLIFY = FALSE
    )

  # get the index (end) of instruments
  i <- which(names(just_data) %in% paste0(instrument_name, "_complete"))
  big_i <- c(0, i)
  n_instr_int <- length(big_i) - 1

  # determine metadata columns
  is_longitudinal <- any(names(just_data) == "redcap_event_name")
  is_repeated <- any(names(just_data) == "redcap_repeat_instrument")

  meta <- if (is_longitudinal && is_repeated) {
    c(1:4)
  } else if (is_repeated) {
    c(1:3)
  } else if (is_longitudinal) {
    c(1:2)
  } else {
    1
  }

  # get filtered record IDs if filter_instrument is specified
  filtered_ids <- NULL
  if (!is.null(filter_instrument) && !is.null(filter_table)) {
    filter_idx <- which(instrument_name == filter_instrument)
    if (length(filter_idx) == 0) {
      stop("filter_instrument '", filter_instrument, "' not found", call. = FALSE)
    }

    filter_data <- extract_instrument_data(filter_idx, big_i, meta, just_data)

    cli_inform("Applying filter to '{filter_instrument}' instrument....")

    temp_table_name <- "filter_temp"
    dbWriteTable(duckdb, temp_table_name, filter_data, overwrite = TRUE)

    filter_tbl <- tbl(duckdb, temp_table_name) |>
      filter_table() |>
      select(all_of(record_id)) |>
      distinct()

    filtered_ids <- filter_tbl |>
      collect() |>
      pull(!!sym(record_id))

    cli_inform("Filter resulted in {length(filtered_ids)} records")
    dbRemoveTable(duckdb, temp_table_name)
  }

  if (n_instr_int == 0) {
    cli_inform("No instruments found in the project.")
    return(if (return_list) list() else invisible())
  }

  # process instruments
  if (return_list) {
    # return as list
    instruments_list <- vector("list", length = n_instr_int)
    names(instruments_list) <- instrument_name[1:n_instr_int]

    for (data_set in seq_len(n_instr_int)) {
      instrument_data <- extract_instrument_data(data_set, big_i, meta, just_data)

      filtered_data <- apply_instrument_filter(
        instrument_data, filtered_ids, filter_table,
        duckdb, data_set, record_id,
        for_env = FALSE
      )

      processed_data <- process_instrument(filtered_data, drop_blank, record_id)

      if (nrow(processed_data) > 0) {
        instruments_list[[instrument_name[data_set]]] <- processed_data
      } else {
        warning(
          paste(
            "The", instrument_name[data_set],
            "instrument/form has 0 records and will be set to NULL in the list. \n"
          ),
          call. = FALSE
        )
        instruments_list[[instrument_name[data_set]]] <- NULL
      }
    }

    return(instruments_list[!sapply(instruments_list, is.null)])
  } else {
    # assign to environment
    for (data_set in seq_len(n_instr_int)) {
      instrument_data <- extract_instrument_data(data_set, big_i, meta, just_data)

      filtered_data <- apply_instrument_filter(
        instrument_data, filtered_ids, filter_table,
        duckdb, data_set, record_id,
        for_env = TRUE
      )

      processed_data <- process_instrument(filtered_data, drop_blank, record_id)

      if (nrow(processed_data) > 0) {
        assign(instrument_name[data_set], processed_data, envir = envir)
      } else {
        warning(
          paste(
            "The", instrument_name[data_set],
            "instrument/form has 0 records and will not be imported. \n"
          ),
          call. = FALSE
        )
      }
    }

    invisible()
  }
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
#' @importFrom stringr str_count str_sub str_extract str_locate
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
    str_count(x, "\\(choice") == 0,
    x,
    paste0(
      str_sub(x, 1, str_locate(x, "\\(choice")[, 1] - 2),
      ": ",
      gsub(re, "\\1", str_extract(x, re))
    )
  )
}
