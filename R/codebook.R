#' @title Generate codebook for REDCap data
#' @description Extract and display metadata information for REDCap data,
#' including variable labels and value labels for categorical variables.
#'
#' @param data A data.frame or single column from REDCap data with metadata attributes
#' @param field_name Character string specifying field name when `data` is a full dataset
#'
#' @return A list or data.frame containing codebook information
#'
#' @examples
#' \dontrun{
#' # Get full codebook for dataset
#' codebook(demographics)
#'
#' # Get codebook for specific variable
#' codebook(demographics$sex)
#' codebook(demographics, "sex")
#' }
#'
#' @export
codebook <- function(data, field_name = NULL) {
  UseMethod("codebook")
}

#' @export
codebook.data.frame <- function(data, field_name = NULL) {
  if (!is.null(field_name)) {
    if (!field_name %in% names(data)) {
      stop("Field '", field_name, "' not found in data", call. = FALSE)
    }
    return(codebook(data[[field_name]], field_name = field_name))
  }

  # Get metadata for all columns
  metadata <- attr(data, "redcap_metadata")
  if (is.null(metadata)) {
    # Fallback: extract info from individual columns
    result <- list()
    for (col_name in names(data)) {
      col_info <- list(
        name = col_name,
        label = attr(data[[col_name]], "label") %||% "No label",
        type = class(data[[col_name]])[1],
        values = extract_value_labels(data[[col_name]])
      )
      result[[col_name]] <- col_info
    }
    return(structure(result, class = "codebook"))
  }

  # Extract codebook from stored metadata
  result <- list()
  for (i in seq_len(nrow(metadata))) {
    field <- metadata[i, ]
    field_name <- field$field_name

    if (field_name %in% names(data)) {
      col_info <- list(
        name = field_name,
        label = field$field_label,
        type = field$field_type,
        note = field$field_note,
        values = parse_choices(field$select_choices_or_calculations)
      )
      result[[field_name]] <- col_info
    }
  }

  structure(result, class = "codebook")
}

#' @export
codebook.default <- function(data, field_name = NULL) {
  # For individual columns
  if (is.null(field_name)) {
    raw_name <- deparse(substitute(data))

    # Extract just the variable name for cleaner display
    if (grepl("\\$", raw_name)) {
      # Extract variable name after $
      field_name <- sub(".*\\$", "", raw_name)
    } else if (grepl("\\[\\[", raw_name)) {
      # Extract variable name from data[[field_name]] pattern
      field_name <- gsub(".*\\[\\[[\"\']?([^\"\'\\]]+)[\"\']?\\]\\]", "\\1", raw_name)
    } else {
      field_name <- raw_name
    }
  }

  structure(list(
    name = field_name,
    label = attr(data, "label") %||% "No label",
    type = class(data)[1],
    values = extract_value_labels(data)
  ), class = "codebook")
}

#' @importFrom cli cli_text cli_ul cli_li cli_h1
#' @export
print.codebook <- function(x, ...) {
  if (!is.null(x$name)) {
    cli_h1("Variable: {.field {x$name}}")
    cli_text("{.strong Label:} {x$label}")
    cli_text("{.strong Type:} {.cls {x$type}}")

    if (!is.null(x$note) && !is.na(x$note)) {
      cli_text("{.strong Note:} {x$note}")
    }

    if (!is.null(x$values) && length(x$values) > 0) {
      cli_text("{.strong Values:}")
      value_items <- character(length(x$values))
      for (i in seq_along(x$values)) {
        val <- names(x$values)[i]
        label <- x$values[[i]]
        value_items[i] <- paste0("{.val ", val, "} = ", label)
      }
      cli_ul(value_items)
    }
  } else {
    for (field_name in names(x)) {
      field <- x[[field_name]]

      cli_h1("Variable: {.field {field$name}}")
      cli_text("{.strong Label:} {field$label}")
      cli_text("{.strong Type:} {.cls {field$type}}")

      if (!is.null(field$note) && !is.na(field$note)) {
        cli_text("{.strong Note:} {field$note}")
      }

      if (!is.null(field$values) && length(field$values) > 0) {
        cli_text("{.strong Values:}")
        value_items <- character(length(field$values))
        for (i in seq_along(field$values)) {
          val <- names(field$values)[i]
          label <- field$values[[i]]
          value_items[i] <- paste0("{.val ", val, "} = ", label)
        }
        cli_ul(value_items)
      }
    }
  }
  invisible(x)
}

# Helper function to parse REDCap choice strings
parse_choices <- function(choices_string) {
  if (is.na(choices_string) || choices_string == "") {
    return(NULL)
  }

  # Split by | and then by comma
  choices <- strsplit(choices_string, " \\| ")[[1]]
  result <- list()

  for (choice in choices) {
    if (grepl(",", choice)) {
      parts <- strsplit(choice, ", ", 2)[[1]]
      if (length(parts) == 2) {
        result[[parts[1]]] <- parts[2]
      }
    }
  }

  if (length(result) == 0) {
    return(NULL)
  }
  result
}

# Helper function to extract value labels from column attributes
extract_value_labels <- function(col) {
  value_labels <- attr(col, "redcap_values")
  if (is.null(value_labels)) {
    return(NULL)
  }
  value_labels
}

# Helper function (equivalent to %||% from rlang)
`%||%` <- function(x, y) if (is.null(x)) y else x
