original_str <- c("No", "Yes", "bob", NA)
original_num <- c(0, 1, 99, NA)
original_lgl <- c(FALSE, TRUE, NA, NA)

target <-
  structure(
    c(1L, 2L, 3L, 3L),
    levels = c("No", "Yes", "Unknown"),
    class = "factor"
  )

test_that("strings work", {
  expect_equal(
    make_yes_no_unknown(original_str),
    target
  )
})

test_that("numerics work", {
  expect_equal(
    make_yes_no_unknown(original_num),
    target
  )
})

test_that("logicals work", {
  expect_equal(
    make_yes_no_unknown(original_lgl),
    target
  )
})


original_df <-
  data.frame(
    original_str,
    original_num,
    original_lgl
  )

target_df <-
  structure(
    list(
      original_str =
        structure(
          c(1L, 2L, 3L, 3L),
          levels = c("No", "Yes", "Unknown"),
          class = "factor"
        ),
      original_num =
        structure(
          c(1L, 2L, 3L, 3L), 
          levels = c("No", "Yes", "Unknown"), 
          class = "factor"
        ),
      original_lgl = 
        structure(
          c(1L, 2L, 3L, 3L), 
          levels = c("No", "Yes", "Unknown"), 
          class = "factor"
        )
    ),
    class = "data.frame", 
    row.names = c(NA, -4L)
  )

test_that("processing works across a df", {
  expect_equal(
    original_df |>
      mutate(across(everything(), make_yes_no_unknown)),
    target_df
  )
})

test_that("labels are preserved for strings", {
  library(labelled)
  original_with_label <- original_str
  var_label(original_with_label) <- "Test question about agreement"
  
  result <- make_yes_no_unknown(original_with_label)
  
  expect_equal(var_label(result), "Test question about agreement")
  expect_equal(as.character(result), as.character(target))
})

test_that("labels are preserved for numerics", {
  library(labelled)
  original_with_label <- original_num
  var_label(original_with_label) <- "Numeric yes/no/unknown response"
  
  result <- make_yes_no_unknown(original_with_label)
  
  expect_equal(var_label(result), "Numeric yes/no/unknown response")
  expect_equal(as.character(result), as.character(target))
})

test_that("labels are preserved for logicals", {
  library(labelled)
  original_with_label <- original_lgl
  var_label(original_with_label) <- "Logical true/false/unknown response"
  
  result <- make_yes_no_unknown(original_with_label)
  
  expect_equal(var_label(result), "Logical true/false/unknown response")
  expect_equal(as.character(result), as.character(target))
})

test_that("function works when no label is present", {
  result <- make_yes_no_unknown(original_str)
  expect_equal(result, target)
  expect_null(var_label(result))
})

test_that("labels are preserved in data frame processing", {
  library(labelled)
  
  # Create labeled data
  labeled_df <- original_df
  var_label(labeled_df$original_str) <- "String responses"
  var_label(labeled_df$original_num) <- "Numeric responses"
  var_label(labeled_df$original_lgl) <- "Logical responses"
  
  # Process with function
  result_df <- labeled_df |>
    mutate(across(everything(), make_yes_no_unknown))
  
  # Check that labels are preserved
  expect_equal(var_label(result_df$original_str), "String responses")
  expect_equal(var_label(result_df$original_num), "Numeric responses")
  expect_equal(var_label(result_df$original_lgl), "Logical responses")
  
  # Check that values are correct
  expect_equal(as.character(result_df$original_str), as.character(target))
  expect_equal(as.character(result_df$original_num), as.character(target))
  expect_equal(as.character(result_df$original_lgl), as.character(target))
})
