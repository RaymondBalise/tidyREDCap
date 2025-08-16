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
#' @param return_list If TRUE, returns instrument data in a named list. If FALSE (default), assigns instrument data to environment.
#' @param filter_instrument Optional character string specifying which instrument
#'   to use for filtering. If provided with filter_function, this instrument will be
#'   filtered first, and the resulting record IDs will be used to filter all
#'   other instruments.
#' @param filter_function Optional function that takes a tbl object and returns
#'   a modified instrument. If `filter_instrument` is specified, this filter is
#'   applied only to that instrument, and resulting record IDs filter all others.
#'   If `filter_instrument` is NULL (default), filter applies to each instrument separately.
#'   Example: \code{function(x) x |> filter(age >= 18)}
#'
#' @return One table (`data.frame`) for each instrument/form in a REDCap project.
#' If `return_list` = TRUE, returns a named list.
#'
#' @importFrom REDCapR redcap_read redcap_metadata_read
#' @importFrom dplyr pull if_else collect tbl select all_of filter distinct sym count
#' @importFrom stringr str_replace str_count str_sub str_extract str_locate
#' @importFrom tidyselect ends_with
#' @importFrom labelVector set_label
#' @importFrom cli cli_inform cli_abort cli_warn
#' @importFrom redquack redcap_to_db
#' @importFrom DBI dbConnect dbDisconnect
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
#'   Sys.getenv("test_API_key"),
#'   return_list = TRUE
#' )
#'
#' # Filter all instruments based on demographics
#' instruments <- import_instruments(
#'   "https://redcap.miami.edu/api/",
#'   Sys.getenv("test_API_key"),
#'   filter_instrument = "demographics",
#'   filter_function = \(x) x |> filter(age >= 18)
#' )
#' }
import_instruments <- function(url, token, drop_blank = TRUE,
                               record_id = "record_id",
                               first_record_id = 1,
                               envir = .GlobalEnv,
                               return_list = FALSE,
                               filter_instrument = NULL,
                               filter_function = NULL) {
  # internal function to extract instrument columns (indices only)
  get_instrument_columns <- function(data_set, big_i, meta) {
    curr_instr_idx <- (big_i[data_set] + 1):big_i[data_set + 1]
    c(meta, curr_instr_idx) |> unique()
  }

  # internal function to apply labels to collected data
  apply_labels_to_data <- function(data, full_labeled_structure) {
    # copy labels from full structure to matching columns in data
    for (col_name in names(data)) {
      if (col_name %in% names(full_labeled_structure)) {
        attr(data[[col_name]], "label") <- attr(full_labeled_structure[[col_name]], "label")
      }
    }
    data
  }

  cli::cli_inform("Reading metadata about your project...")

  ds_instrument <- suppressWarnings(suppressMessages(
    redcap_metadata_read(redcap_uri = url, token = token)$data
  ))

  # get instrument names
  instrument_name <- ds_instrument |>
    pull(form_name) |>
    unique()

  # validate filter_instrument
  if (!is.null(filter_instrument) && !filter_instrument %in% instrument_name) {
    stop("filter_instrument '", filter_instrument, "' not found in project instruments: ",
      paste(instrument_name, collapse = ", "),
      call. = FALSE
    )
  }

  cli::cli_inform("Reading variable labels...")
  raw_labels <- suppressWarnings(suppressMessages(
    redcap_read(
      redcap_uri = url, token = token,
      raw_or_label_headers = "label",
      records = first_record_id
    )$data
  ))

  if (nrow(raw_labels) == 0) {
    stop("The first 'record_id' must be 1; use argument 'first_record_id' to set first id",
      call. = FALSE
    )
  }

  # prepare labels
  label_names <- names(raw_labels) |>
    str_replace("(\\(.*)\\(", "\\1") |>
    str_replace("\\)(.*\\))", "\\1")
  names(label_names) <- names(raw_labels)

  cli::cli_inform("Reading your data...")

  # create temporary duckdb connection
  db_file <- tempfile(fileext = ".duckdb")
  duckdb <- dbConnect(duckdb(), db_file)

  on.exit({
    dbDisconnect(duckdb)
    if (file.exists(db_file)) file.remove(db_file)
  })

  # import redcap data to duckdb
  redcap_to_db(
    conn = duckdb, redcap_uri = url, token = token,
    record_id_name = record_id, echo = "progress", beep = FALSE
  )

  # get data table reference and apply labels to full structure
  data_tbl <- tbl(duckdb, "data")

  # check data size and warn if big
  filter_in_use <- !is.null(filter_instrument) || !is.null(filter_function)
  if (!filter_in_use) {
    n_rows <- data_tbl |>
      count() |>
      collect() |>
      pull(n)
    n_cols <- length(colnames(data_tbl))
    total_elements <- n_rows * n_cols

    if (total_elements >= 100000000) { # 100m elements - serious warning
      cli::cli_warn("Your very large REDCap project ({n_rows} obs. of {n_cols} variables) may exceed memory and require arguments {.arg filter_function} and {.arg filter_instrument} to import filtered data")
    } else if (total_elements >= 25000000) { # 25m elements - suggestion
      cli::cli_alert_info("Consider filtering your somewhat large REDCap project ({n_rows} obs. of {n_cols} variables) using arguments {.arg filter_function} and {.arg filter_instrument} for better performance")
    }
  }

  # collect a sample to get full column structure for labeling
  full_structure <- data_tbl |>
    head(1) |>
    collect()

  # apply labels to the full structure template
  full_structure[] <- mapply(
    nm = names(full_structure),
    lab = relabel(label_names),
    FUN = function(nm, lab) set_label(full_structure[[nm]], lab),
    SIMPLIFY = FALSE
  )

  # get instrument indices
  i <- which(names(full_structure) %in% paste0(instrument_name, "_complete"))
  big_i <- c(0, i)
  n_instr_int <- length(big_i) - 1

  # determine metadata columns
  is_longitudinal <- any(names(full_structure) == "redcap_event_name")
  is_repeated <- any(names(full_structure) == "redcap_repeat_instrument")

  meta <- if (is_longitudinal && is_repeated) {
    c(1:4)
  } else if (is_repeated) {
    c(1:3)
  } else if (is_longitudinal) {
    c(1:2)
  } else {
    1
  }

  # get filtered record ids if filter specified
  filtered_ids <- NULL
  if (!is.null(filter_instrument) && !is.null(filter_function)) {
    filter_idx <- which(instrument_name == filter_instrument)

    cli::cli_inform("Applying filter to '{filter_instrument}' instrument...")

    # get column indices for filter instrument
    filter_columns <- get_instrument_columns(filter_idx, big_i, meta)

    # apply filter directly on database table
    filtered_ids <- data_tbl |>
      select(all_of(filter_columns)) |>
      select(-ends_with(".1")) |>
      filter_function() |>
      select(all_of(record_id)) |>
      distinct() |>
      collect() |>
      pull(!!sym(record_id))

    cli::cli_inform("Filter resulted in {length(filtered_ids)} records")
  }

  if (n_instr_int == 0) {
    cli::cli_inform("No instruments found in project")
    return(if (return_list) list() else invisible())
  }

  # process instruments with memory-efficient approach
  if (return_list) {
    instruments_list <- vector("list", length = n_instr_int)
    names(instruments_list) <- instrument_name[1:n_instr_int]

    for (data_set in seq_len(n_instr_int)) {
      # get column indices for this instrument
      column_index <- get_instrument_columns(data_set, big_i, meta)

      # build query starting from database table
      instrument_query <- data_tbl |>
        select(all_of(column_index)) |>
        select(-ends_with(".1"))

      # apply filtering if needed
      if (!is.null(filtered_ids)) {
        instrument_query <- instrument_query |>
          filter(!!sym(record_id) %in% filtered_ids)
      } else if (!is.null(filter_function)) {
        instrument_query <- instrument_query |> filter_function()
      }

      # collect data
      instrument_data <- instrument_query |> collect()

      # apply labels
      instrument_data <- apply_labels_to_data(instrument_data, full_structure)

      # process (drop blank if needed)
      processed_data <- if (drop_blank) {
        make_instrument_auto(instrument_data, record_id = record_id)
      } else {
        instrument_data
      }

      rownames(processed_data) <- NULL

      if (nrow(processed_data) > 0) {
        instruments_list[[instrument_name[data_set]]] <- processed_data
      } else {
        warning("The ", instrument_name[data_set],
          " instrument has 0 records and will be set to null",
          call. = FALSE
        )
        instruments_list[[instrument_name[data_set]]] <- NULL
      }
    }

    return(instruments_list[!sapply(instruments_list, is.null)])
  } else {
    # assign to environment
    for (data_set in seq_len(n_instr_int)) {
      column_index <- get_instrument_columns(data_set, big_i, meta)

      instrument_query <- data_tbl |>
        select(all_of(column_index)) |>
        select(-ends_with(".1"))

      if (!is.null(filtered_ids)) {
        instrument_query <- instrument_query |>
          filter(!!sym(record_id) %in% filtered_ids)
      } else if (!is.null(filter_function)) {
        instrument_query <- instrument_query |> filter_function()
      }

      # collect data
      instrument_data <- instrument_query |> collect()

      instrument_data <- apply_labels_to_data(instrument_data, full_structure)

      processed_data <- if (drop_blank) {
        make_instrument_auto(instrument_data, record_id = record_id)
      } else {
        instrument_data
      }

      rownames(processed_data) <- NULL

      if (nrow(processed_data) > 0) {
        assign(instrument_name[data_set], processed_data, envir = envir)
      } else {
        cli::cli_warn(
          "The {instrument_name[data_set]} instrument has 0 records and will not be imported"
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
