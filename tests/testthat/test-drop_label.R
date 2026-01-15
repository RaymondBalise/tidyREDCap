demographics <- structure(
  list(
    record_id = c(1, 2, 3, 4, 5),
    name_first = structure(
      c("Nutmeg", "Tumtum", "Marcus", "Trudy", "John Lee"),
      label = "First Name",
      class = c("labelled", "character")
    ), 
    name_last = structure(
      c("Nutmouse", "Nutmouse", "Wood", "DAG", "Walker"),
      label = "Last Name",
      class = c("labelled", "character")
    ),
    address = structure(
      c(
        "14 Rose Cottage St.\nKenning UK, 323232",
        "14 Rose Cottage Blvd.\nKenning UK 34243",
        "243 Hill St.\nGuthrie OK 73402",
        "342 Elm\nDuncanville TX, 75116",
        "Hotel Suite\nNew Orleans LA, 70115"
      ),
      label = "Street, City, State, ZIP",
      class = c("labelled", "character")
    ),
    telephone = structure(
      c(
        "(405) 321-1111",
        "(405) 321-2222",
        "(405) 321-3333",
        "(405) 321-4444",
        "(405) 321-5555"
      ),
      label = "Phone number",
      class = c("labelled", "character")
    ), email = structure(
      c(
        "nutty@mouse.com",
        "tummy@mouse.comm",
        "mw@mwood.net",
        "peroxide@blonde.com",
        "left@hippocket.com"
      ),
      label = "E-mail",
      class = c("labelled", "character")
    ),
    dob = structure(
      c(12294, 12121, -13051, -6269, -5375),
      class = c("labelled", "Date"),
      label = "Date of birth"
    ),
    age = structure(
      c(11, 11, 80, 61, 59),
      label = "Age (years)",
      class = c("labelled", "numeric")
    ),
    days = structure(
      c(1, 2, 3, 4, 5),
      label = "Days",
      class = c("labelled", "numeric")
    ),    
    sex = structure(
      c("Female", "Male", "Male", "Female", "Male"),
      label = "Gender",
      class = c("labelled", "character")
    ),
    demographics_complete = structure(
      c("Complete", "Complete", "Complete", "Complete", "Complete"),
      label = "Complete?...10",
      class = c("labelled", "character")
    )
  ),
  row.names = c(NA, -5L),
  class = "data.frame"
)

test_that("drop_label() removes all labels when no variables specified", {
  result <- drop_label(demographics)
  
  # Check that label attribute is removed from all columns
  expect_null(attr(result$name_first, "label"))
  expect_null(attr(result$name_last, "label"))
  
  # Check that "labelled" class is removed but base class preserved
  expect_false("labelled" %in% class(result$name_first))
  expect_true("character" %in% class(result$name_first))
})

test_that("drop_label() removes label from single variable", {
  result <- drop_label(demographics, name_first)
  
  # name_first should have label removed
  expect_null(attr(result$name_first, "label"))
  expect_false("labelled" %in% class(result$name_first))
  expect_true("character" %in% class(result$name_first))
  
  # name_last should still have label
  expect_equal(attr(result$name_last, "label"), "Last Name")
  expect_true("labelled" %in% class(result$name_last))
})

test_that("drop_label() removes labels from multiple variables", {
  result <- drop_label(demographics, name_first, name_last)
  
  # Both should have labels removed
  expect_null(attr(result$name_first, "label"))
  expect_null(attr(result$name_last, "label"))
  expect_false("labelled" %in% class(result$name_first))
  expect_false("labelled" %in% class(result$name_last))
  
  # Other columns should still have labels (if they had them)
  if ("labelled" %in% class(demographics$email)) {
    expect_true("labelled" %in% class(result$email))
  }
})

test_that("drop_label() works with tidyselect helpers", {
  result <- drop_label(demographics, contains('name'))
  
  # Variables containing 'name' should have labels removed
  expect_null(attr(result$name_first, "label"))
  expect_null(attr(result$name_last, "label"))
  expect_false("labelled" %in% class(result$name_first))
  expect_false("labelled" %in% class(result$name_last))
})

test_that("drop_label() works inside mutate() with single variable", {
  result <- demographics |> 
    mutate(name_first = drop_label(name_first))
  
  # name_first should have label removed
  expect_null(attr(result$name_first, "label"))
  expect_false("labelled" %in% class(result$name_first))
  
  # name_last should still have label
  expect_equal(attr(result$name_last, "label"), "Last Name")
})

test_that("drop_label() works inside mutate() with across()", {
  result <- demographics |> 
    mutate(across(contains('name'), drop_label))
  
  # Both name variables should have labels removed
  expect_null(attr(result$name_first, "label"))
  expect_null(attr(result$name_last, "label"))
  expect_false("labelled" %in% class(result$name_first))
  expect_false("labelled" %in% class(result$name_last))
})

test_that("drop_label() errors when variable is quoted in mutate()", {
  expect_error(
    demographics |> mutate(name_first = drop_label('name_first')),
    "quoted your variable"
  )
})

test_that("drop_label() preserves data frame class", {
  # Test with base data.frame
  df_base <- as.data.frame(demographics)
  result_base <- drop_label(df_base)
  expect_s3_class(result_base, "data.frame")
  expect_false(inherits(result_base, "tbl_df"))
  
  # Test with tibble
  df_tibble <- tibble::as_tibble(demographics)
  result_tibble <- drop_label(df_tibble)
  expect_s3_class(result_tibble, "tbl_df")
})

test_that("drop_labels() shows deprecation warning", {
  lifecycle::expect_deprecated(
    drop_labels(demographics),
    "drop_labels.*deprecated.*drop_label"
  )
})

test_that("drop_label() on quoted variable doesn't work at dataset level", {
  # This should process the variable 'name_first' (not error)
  # Quoting is only an error inside mutate()
  result <- drop_label(demographics, 'name_first')
  expect_null(attr(result$name_first, "label"))
})