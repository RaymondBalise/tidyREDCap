# Tests for codebook functionality
# 2025-09-09

library(testthat)
library(tidyREDCap)

test_that("codebook works with REDCap data", {
  # Import test data with metadata
  demo_data <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE
  )
  
  # Test full dataset codebook
  cb_full <- codebook(demo_data$demographics)
  expect_s3_class(cb_full, "codebook")
  expect_true("sex" %in% names(cb_full))
  expect_equal(cb_full$sex$label, "Gender")
  expect_equal(cb_full$sex$type, "radio")
  expect_equal(cb_full$sex$values[["0"]], "Female")
  expect_equal(cb_full$sex$values[["1"]], "Male")
  
  # Test individual variable codebook  
  cb_sex <- codebook(demo_data$demographics$sex)
  expect_equal(cb_sex$label, "Gender")
  expect_equal(cb_sex$values[["0"]], "Female")
  expect_equal(cb_sex$values[["1"]], "Male")
  
  # Test that value labels are stored as attributes
  expect_equal(attr(demo_data$demographics$sex, "redcap_values")[["0"]], "Female")
  expect_equal(attr(demo_data$demographics$sex, "redcap_values")[["1"]], "Male")
  
  # Test that dataset metadata is stored
  expect_true(!is.null(attr(demo_data$demographics, "redcap_metadata")))
  expect_true("field_name" %in% names(attr(demo_data$demographics, "redcap_metadata")))
})

test_that("codebook works with specific field name", {
  demo_data <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B", 
    return_list = TRUE
  )
  
  # Test using field name parameter
  cb_sex <- codebook(demo_data$demographics, "sex")
  expect_equal(cb_sex$label, "Gender")
  expect_equal(cb_sex$values[["0"]], "Female")
  expect_equal(cb_sex$values[["1"]], "Male")
})

test_that("codebook handles non-existent fields gracefully", {
  demo_data <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE
  )
  
  expect_error(
    codebook(demo_data$demographics, "nonexistent_field"),
    'Field "nonexistent_field" not found in data'
  )
})

test_that("codebook works with data without metadata", {
  # Test with regular data.frame without metadata
  simple_df <- data.frame(
    x = 1:3,
    y = letters[1:3]
  )
  
  cb <- codebook(simple_df)
  expect_s3_class(cb, "codebook")
  expect_true("x" %in% names(cb))
  expect_equal(cb$x$label, "No label")
})

test_that("codebook_convert works with REDCap data", {
  # Skip if can't connect to test REDCap
  skip_if_not(require("httr", quietly = TRUE))
  
  # Import test data with metadata
  demo_data <- tryCatch({
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "9A81268476645C4E5F03428B8AC3AA7B",
      return_list = TRUE
    )
  }, error = function(e) {
    skip("Cannot connect to test REDCap server")
    NULL
  })
  
  skip_if(is.null(demo_data))
  
  # Find a column with redcap_values for testing
  test_col_name <- NULL
  for (col_name in names(demo_data$demographics)) {
    if (!is.null(attr(demo_data$demographics[[col_name]], "redcap_values"))) {
      test_col_name <- col_name
      break
    }
  }
  
  # If no column with redcap_values, create a test case
  if (is.null(test_col_name)) {
    # Create manual test data
    demo_data$demographics$test_convert <- c(0, 1, 1, 0, 1)
    attr(demo_data$demographics$test_convert, "redcap_values") <- list("0" = "No", "1" = "Yes")
    test_col_name <- "test_convert"
  }
  
  # Test converting single column
  col_converted <- codebook_convert(demo_data$demographics[[test_col_name]])
  expect_type(col_converted, "character")
  
  # Test converting specific column in data.frame (should return column vector)
  demo_converted_col <- codebook_convert(demo_data$demographics, test_col_name)
  expect_type(demo_converted_col, "character")
  expect_false(is.data.frame(demo_converted_col))  # Should not be a data.frame
  
  # Test that calling without column name gives helpful error
  expect_error(
    codebook_convert(demo_data$demographics),
    "When converting multiple columns, use dplyr patterns"
  )
})

test_that("codebook_convert handles data without value labels", {
  # Test with column that has no redcap_values attribute
  simple_col <- c(1, 2, 3)
  result <- codebook_convert(simple_col)
  expect_identical(result, simple_col)
  
  # Test with data.frame column that has no metadata
  simple_df <- data.frame(x = 1:3, y = letters[1:3])
  result <- codebook_convert(simple_df, "x")
  expect_identical(result, simple_df$x)
})

test_that("codebook_convert handles non-existent columns gracefully", {
  demo_data <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE
  )
  
  expect_error(
    codebook_convert(demo_data$demographics, "nonexistent_column"),
    'Column "nonexistent_column" not found in data'
  )
})

test_that("codebook_convert preserves NAs and attributes", {
  # Create test column with value labels and NAs
  test_col <- c(0, 1, NA, 0, 1)
  attr(test_col, "redcap_values") <- list("0" = "No", "1" = "Yes")
  attr(test_col, "label") <- "Test Label"
  
  result <- codebook_convert(test_col)
  expect_type(result, "character")
  expect_equal(result[!is.na(result)], c("No", "Yes", "No", "Yes"))
  expect_true(is.na(result[3]))
  expect_equal(attr(result, "label"), "Test Label")
  expect_null(attr(result, "redcap_values"))
})

test_that("codebook_convert handles logical values as 0/1 codes", {
  # Create logical column that should be treated as 0/1 codes
  logical_col <- c(FALSE, TRUE, TRUE, FALSE, TRUE)
  attr(logical_col, "redcap_values") <- list("0" = "Female", "1" = "Male")
  attr(logical_col, "label") <- "Gender"
  
  result <- codebook_convert(logical_col)
  expect_type(result, "character")
  expect_equal(as.vector(result), c("Female", "Male", "Male", "Female", "Male"))
  expect_equal(attr(result, "label"), "Gender")
  expect_null(attr(result, "redcap_values"))
})

test_that("codebook_convert works with mixed numeric and string codes", {
  # Test with both numeric and string codes
  mixed_col <- c("A", "B", "A", "C")
  attr(mixed_col, "redcap_values") <- list("A" = "Option A", "B" = "Option B", "C" = "Option C")
  
  result <- codebook_convert(mixed_col)
  expect_equal(result, c("Option A", "Option B", "Option A", "Option C"))
  
  # Test with numeric codes as strings
  numeric_col <- c(1, 2, 1, 3)
  attr(numeric_col, "redcap_values") <- list("1" = "First", "2" = "Second", "3" = "Third")
  
  result2 <- codebook_convert(numeric_col)
  expect_equal(result2, c("First", "Second", "First", "Third"))
})

test_that("has_redcap_values helper function works", {
  # Column with redcap_values
  col_with_values <- c(0, 1, 1, 0)
  attr(col_with_values, "redcap_values") <- list("0" = "No", "1" = "Yes")
  expect_true(has_redcap_values(col_with_values))
  
  # Column without redcap_values
  col_without_values <- c(1, 2, 3)
  expect_false(has_redcap_values(col_without_values))
  
  # Column with other attributes but no redcap_values
  col_with_other_attrs <- c(1, 2, 3)
  attr(col_with_other_attrs, "label") <- "Test Label"
  expect_false(has_redcap_values(col_with_other_attrs))
})