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

codebook.data.frame <- function(data, field_name = NULL) {
  if (!is.null(field_name)) {
    if (!field_name %in% names(data)) {
      cli_abort("Field {.val {field_name}} not found in data")
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

#' @importFrom cli cli_text cli_ul cli_li cli_h1 cli_abort
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

#' @title Convert coded values using codebook metadata
#' @description Converts coded values in REDCap data to their labeled equivalents
#' using the metadata stored in column attributes. Both syntaxes return the converted
#' column vector for consistency with codebook(). For data.frame operations, use
#' standard tidy patterns with mutate().
#'
#' @param data A data.frame, single column, or data.frame with column name specification
#' @param col_name Character string specifying column name when `data` is a data.frame
#'
#' @return Converted column vector with coded values replaced by labels
#'
#' @examples
#' \dontrun{
#' # Both return converted column vector
#' codebook_convert(demographics$sex)
#' codebook_convert(demographics, "sex")
#'
#' # For data.frame operations, use tidy patterns:
#' demographics |>
#'   mutate(sex = codebook_convert(sex))
#'
#' # Convert multiple columns
#' demographics |>
#'   mutate(across(where(has_redcap_values), codebook_convert))
#'
#' # Convert specific columns
#' demographics |>
#'   mutate(
#'     sex = codebook_convert(sex),
#'     race = codebook_convert(race)
#'   )
#' }
#'
#' @export
codebook_convert <- function(data, col_name = NULL) {
  UseMethod("codebook_convert")
}

codebook_convert.data.frame <- function(data, col_name = NULL) {
  if (!is.null(col_name)) {
    if (!col_name %in% names(data)) {
      cli_abort("Column {.val {col_name}} not found in data")
    }
    # Return just the converted column to maintain consistency with codebook()
    return(codebook_convert(data[[col_name]]))
  }

  # When no column specified, error with helpful message about tidy approach
  cli_abort(c(
    "When converting multiple columns, use dplyr patterns like:",
    "i" = "data |> mutate(across(where(has_redcap_values), codebook_convert))",
    "i" = "data |> mutate(col1 = codebook_convert(col1), col2 = codebook_convert(col2))"
  ))
}

codebook_convert.default <- function(data, col_name = NULL) {
  value_labels <- attr(data, "redcap_values")

  if (is.null(value_labels) || length(value_labels) == 0) {
    return(data)
  }

  # Convert to character to handle case_when-like logic
  result <- as.character(data)

  # Handle the case where logical values need to be treated as numeric (0/1)
  # This happens when REDCap 0/1 codes get converted to logical by import process
  lookup_data <- data
  if (is.logical(data)) {
    # Convert logical to numeric for lookup: FALSE = 0, TRUE = 1
    lookup_data <- as.numeric(data)
  }

  # Apply conversions for each coded value
  for (code in names(value_labels)) {
    # Try both string and numeric comparison for robust matching
    code_numeric <- suppressWarnings(as.numeric(code))
    if (!is.na(code_numeric)) {
      # For numeric codes, match against numeric conversion of the data
      result[lookup_data == code_numeric] <- value_labels[[code]]
    } else {
      # For string codes, match against character conversion
      result[as.character(lookup_data) == code] <- value_labels[[code]]
    }
  }

  # Handle NAs appropriately - keep as NA if original was NA
  result[is.na(data)] <- NA_character_

  # Preserve original attributes except redcap_values (since we've converted)
  attributes_to_keep <- attributes(data)
  attributes_to_keep$redcap_values <- NULL

  attributes(result) <- c(attributes(result), attributes_to_keep)

  result
}

#' @title Check if column has REDCap value labels
#' @description Helper function to identify columns with redcap_values attributes.
#' Useful with dplyr::across() for selective conversion.
#'
#' @param x A column/vector to check
#'
#' @return Logical indicating whether column has redcap_values attribute
#'
#' @examples
#' \dontrun{
#' # Convert only columns with value labels
#' demographics |>
#'   mutate(across(where(has_redcap_values), codebook_convert))
#' }
#'
#' @export
has_redcap_values <- function(x) {
  !is.null(attr(x, "redcap_values"))
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
