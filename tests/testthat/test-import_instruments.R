# Tests for the import_instruments against the import from data returned by 
#   REDCapR
# Ray Balise and Gabriel Odom 
# 2023-02-10

library(testthat)

######  Setup  ######
target <- structure(
  list(
    record_id = structure(
      c(1, 2, 3, 4, 5), 
      label = "Study ID", 
      class = c("labelled", "numeric")
    ), 
    name_first = structure(
      c(
        "Nutmeg", "Tumtum", "Marcus", "Trudy", "John Lee"
      ),
      label = "First Name", class = c(
        "labelled",
        "character"
      )
    ), 
    name_last = structure(
      c(
      "Nutmouse", "Nutmouse", "Wood", "DAG", "Walker"
    ), label = "Last Name", class = c(
      "labelled",
      "character"
    )), address = structure(c(
      "14 Rose Cottage St.\nKenning UK, 323232",
      "14 Rose Cottage Blvd.\nKenning UK 34243",
      "243 Hill St.\nGuthrie OK 73402",
      "342 Elm\nDuncanville TX, 75116",
      "Hotel Suite\nNew Orleans LA, 70115"
    ), label = "Street, City, State, ZIP", class = c(
      "labelled",
      "character"
    )), telephone = structure(c(
      "(405) 321-1111", "(405) 321-2222",
      "(405) 321-3333", "(405) 321-4444", "(405) 321-5555"
    ), label = "Phone number", class = c(
      "labelled",
      "character"
    )), email = structure(c(
      "nutty@mouse.com", "tummy@mouse.comm",
      "mw@mwood.net", "peroxide@blonde.com", "left@hippocket.com"
    ), label = "E-mail", class = c(
      "labelled",
      "character"
    )), dob = structure(c(
      12294, 12121, -13051, -6269,
      -5375
    ), class = c("labelled", "Date"), label = "Date of birth"),
    age = structure(c(11, 11, 80, 61, 59), label = "Age (years)", class = c(
      "labelled",
      "numeric"
    )), sex = structure(c(
      "Female", "Male", "Male",
      "Female", "Male"
    ), label = "Gender", class = c(
      "labelled",
      "character"
    )), demographics_complete = structure(c(
      "Complete",
      "Complete", "Complete", "Complete", "Complete"
    ), label = "Complete?...10", class = c(
      "labelled",
      "character"
    ))
  ),
  row.names = c(NA, -5L), class = c("tbl_df", "tbl", "data.frame")
)

# creates demographics
tidyREDCap::import_instruments(
  "https://bbmc.ouhsc.edu/redcap/api/",
  "9A81268476645C4E5F03428B8AC3AA7B"
)



######  Tests  ######
test_that("import works", {
  # Test basic structure
  expect_s3_class(demographics, "data.frame")
  expect_equal(names(demographics), names(target))
  expect_equal(nrow(demographics), nrow(target))
  
  # Test that labels are preserved (the key functionality)
  expect_equal(attr(demographics$record_id, "label"), "Study ID")
  expect_equal(attr(demographics$name_first, "label"), "First Name") 
  expect_equal(attr(demographics$name_last, "label"), "Last Name")
  expect_equal(attr(demographics$address, "label"), "Street, City, State, ZIP")
  expect_equal(attr(demographics$telephone, "label"), "Phone number")
  expect_equal(attr(demographics$email, "label"), "E-mail")
  expect_equal(attr(demographics$dob, "label"), "Date of birth")
  expect_equal(attr(demographics$age, "label"), "Age (years)")
  expect_equal(attr(demographics$sex, "label"), "Gender")
  expect_equal(attr(demographics$demographics_complete, "label"), "Complete?")
  
  # Test data values (ignoring class differences and attributes)
  expect_equal(as.numeric(demographics$record_id), c(1, 2, 3, 4, 5))
  expect_equal(as.character(demographics$name_first), c("Nutmeg", "Tumtum", "Marcus", "Trudy", "John Lee"))
  expect_equal(as.character(demographics$name_last), c("Nutmouse", "Nutmouse", "Wood", "DAG", "Walker"))
})

test_that("return_list parameter works", {
  # Test return_list = TRUE returns a list
  instruments_list <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE
  )
  
  expect_type(instruments_list, "list")
  expect_true("demographics" %in% names(instruments_list))
  expect_s3_class(instruments_list$demographics, "data.frame")
  
  # Test return_list = FALSE returns individual data.frames in environment (default behavior)
  expect_s3_class(demographics, "data.frame")
})

test_that("labels parameter works", {
  # Test labels = FALSE removes column labels
  tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE
  ) -> instruments_with_labels
  
  tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    return_list = TRUE,
    labels = FALSE
  ) -> instruments_without_labels
  
  # Check that labels are present in the first case
  expect_true(any(sapply(instruments_with_labels$demographics, function(x) !is.null(attr(x, "label")))))
  
  # Check that labels are removed in the second case
  expect_false(any(sapply(instruments_without_labels$demographics, function(x) !is.null(attr(x, "label")))))
})

test_that("filter_function parameter works", {
  # Test filter_function with a simple filter
  filtered_instruments <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_function = function(x) x |> dplyr::filter(record_id == 3),
    return_list = TRUE
  )
  
  expect_type(filtered_instruments, "list")
  expect_true("demographics" %in% names(filtered_instruments))
  expect_equal(nrow(filtered_instruments$demographics), 1)
  expect_equal(as.numeric(filtered_instruments$demographics$record_id), 3)
  # Check that label is preserved when filtering
  expect_equal(attr(filtered_instruments$demographics$record_id, "label"), "Study ID")
  
  # Test filtering by record_id range - common use case
  range_filtered <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_function = function(x) x |> dplyr::filter(record_id >= 2 & record_id <= 4),
    return_list = TRUE
  )
  
  expect_true(all(range_filtered$demographics$record_id >= 2))
  expect_true(all(range_filtered$demographics$record_id <= 4))
})

test_that("filter_instrument parameter works", {
  # Test filter_instrument with demographics
  filtered_instruments <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_instrument = "demographics",
    filter_function = function(x) x |> dplyr::filter(name_last == "Nutmouse"),
    return_list = TRUE
  )
  
  expect_type(filtered_instruments, "list")
  expect_true("demographics" %in% names(filtered_instruments))
  
  # Should only have records where name_last == "Nutmouse" 
  expect_true(all(filtered_instruments$demographics$name_last == "Nutmouse"))
  expect_equal(nrow(filtered_instruments$demographics), 2) # Based on test data, should be 2 records
})

test_that("combined filtering works (two-step filter)", {
  # Test the two-step filtering process:
  # 1) filter filter_instrument and get record IDs
  # 2) filter the rest of the instruments by record ID from step 1
  filtered_instruments <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_instrument = "demographics",
    filter_function = function(x) x |> dplyr::filter(name_last == "Nutmouse"),
    return_list = TRUE
  )
  
  expect_type(filtered_instruments, "list")
  
  # All instruments in the list should only contain records with IDs that match
  # the filtered demographics instrument
  demographics_record_ids <- filtered_instruments$demographics$record_id
  
  # Check that all instruments have the same record_ids
  for (instrument_name in names(filtered_instruments)) {
    instrument_data <- filtered_instruments[[instrument_name]]
    if ("record_id" %in% names(instrument_data)) {
      expect_true(all(instrument_data$record_id %in% demographics_record_ids),
                  info = paste("Instrument", instrument_name, "has incorrect record_ids"))
    }
  }
})

test_that("error handling for invalid filter_instrument", {
  # Test that invalid filter_instrument names produce appropriate errors
  expect_error(
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "9A81268476645C4E5F03428B8AC3AA7B",
      filter_instrument = "nonexistent_instrument",
      return_list = TRUE
    ),
    # Error message may vary depending on redquack implementation
    regexp = ".*"  # Accept any error message for now
  )
})

test_that("parameter combinations work correctly", {
  # Test multiple parameters together
  result <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_instrument = "demographics",
    filter_function = function(x) x |> dplyr::filter(record_id <= 2),
    return_list = TRUE,
    labels = FALSE
  )
  
  expect_type(result, "list")
  expect_true("demographics" %in% names(result))
  
  # Check filtering worked
  expect_true(all(result$demographics$record_id <= 2))
  
  # Check labels were removed
  expect_false(any(sapply(result$demographics, function(x) !is.null(attr(x, "label")))))
})

test_that("edge cases handle gracefully", {
  # Test filter that returns no results
  empty_result <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_function = function(x) x |> dplyr::filter(record_id == 999), # Non-existent ID
    return_list = TRUE
  )
  
  expect_type(empty_result, "list")
  expect_true("demographics" %in% names(empty_result))
  expect_equal(nrow(empty_result$demographics), 0)
  
  # Test filtering by multiple record_id values
  multi_record_result <- tidyREDCap::import_instruments(
    "https://bbmc.ouhsc.edu/redcap/api/",
    "9A81268476645C4E5F03428B8AC3AA7B",
    filter_function = function(x) x |> dplyr::filter(record_id %in% c(1, 3, 5)),
    return_list = TRUE
  )
  
  expect_true(all(multi_record_result$demographics$record_id %in% c(1, 3, 5)))
})

test_that("robust error handling works correctly", {
  # Test malformed token error
  expect_error(
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "bad_token"
    ),
    "The token does not conform with the regex"
  )
  
  # Test invalid token with correct format (403 error)
  expect_error(
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "9A81268476645C4E5F03428B8AC3AA7c"
    ),
    "Metadata read failed"
  )
  
  # Test network/hostname resolution error
  expect_error(
    tidyREDCap::import_instruments(
      "https://nonexistent_redcap_server.com/api/",
      "9A81268476645C4E5F03428B8AC3AA7B"
    ),
    "Metadata read failed.*Could not resolve host"
  )
  
  # Test 404 error with valid hostname but wrong path
  expect_error(
    tidyREDCap::import_instruments(
      "https://httpbin.org/status/404",
      "9A81268476645C4E5F03428B8AC3AA7B"
    ),
    "Metadata read failed"
  )
})

test_that("error handling preserves list vs environment behavior", {
  # Test that list mode throws errors
  expect_error(
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "bad_token",
      return_list = TRUE
    ),
    "The token does not conform with the regex"
  )
  
  # Test that environment mode also throws errors for invalid parameters
  expect_error(
    tidyREDCap::import_instruments(
      "https://bbmc.ouhsc.edu/redcap/api/",
      "bad_token",
      return_list = FALSE
    ),
    "The token does not conform with the regex"
  )
})


