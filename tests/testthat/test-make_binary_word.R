test_that("binary_word_basic", {
  
  test_df <- data.frame(
    q1 = c("Unchecked", "Checked"),
    q2 = c("Unchecked", "Unchecked"),
    q3 = c("Checked", "Checked"),
    q4 = c("Checked", "Unchecked"),
    stringsAsFactors = FALSE
  )
  
  expect_equal(
    make_binary_word(test_df),
    c("__cd", "a_c_")
  )
  
})
