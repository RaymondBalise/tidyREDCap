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

test_that("strings work", {
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
