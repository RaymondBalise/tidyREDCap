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
    "Field 'nonexistent_field' not found in data"
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