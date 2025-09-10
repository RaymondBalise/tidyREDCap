
original_str = c("No", "Yes", "bob", NA)
original_num = c(0, 1, 99, NA)
original_lgl = c(FALSE, TRUE, NA, NA)

target <- 
  structure(
    c(1L, 2L, 1L, 1L), 
    levels = c("No or Unknown", "Yes"), 
    class = "factor"
  )

test_that("strings work", {
  expect_equal(
    make_yes_no(original_str),
    target)
})

test_that("numerics work", {
  expect_equal(
    make_yes_no(original_num),
    target)
})

test_that("logicals work", {
  expect_equal(
    make_yes_no(original_lgl),
    target)
})

test_that("labels are preserved for strings", {
  library(labelled)
  original_with_label <- original_str
  var_label(original_with_label) <- "Test question about agreement"
  
  result <- make_yes_no(original_with_label)
  
  expect_equal(var_label(result), "Test question about agreement")
  expect_equal(as.character(result), as.character(target))
})

test_that("labels are preserved for numerics", {
  library(labelled)
  original_with_label <- original_num
  var_label(original_with_label) <- "Numeric yes/no response"
  
  result <- make_yes_no(original_with_label)
  
  expect_equal(var_label(result), "Numeric yes/no response")
  expect_equal(as.character(result), as.character(target))
})

test_that("labels are preserved for logicals", {
  library(labelled)
  original_with_label <- original_lgl
  var_label(original_with_label) <- "Logical true/false response"
  
  result <- make_yes_no(original_with_label)
  
  expect_equal(var_label(result), "Logical true/false response")
  expect_equal(as.character(result), as.character(target))
})

test_that("function works when no label is present", {
  result <- make_yes_no(original_str)
  expect_equal(result, target)
  expect_null(var_label(result))
})
