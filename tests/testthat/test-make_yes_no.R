
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

test_that("strings work", {
  expect_equal(
    make_yes_no(original_num),
    target)
})

test_that("logicals work", {
  expect_equal(
    make_yes_no(original_lgl),
    target)
})
