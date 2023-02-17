# Tests for the drop_labels function against one-column data frame (and others)
# Ray Balise and Gabriel Odom 
# 2023-02-17


######  Setup  ######
original <- structure(
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

# Visually check that we see column attributes displayed correctly
# View(original)

target <- structure(
  list(
    record_id = c(1, 2, 3, 4, 5),
    name_first = c(
      "Nutmeg", "Tumtum", "Marcus", "Trudy", "John Lee"
    ),
    name_last = c(
      "Nutmouse", "Nutmouse", "Wood", "DAG", "Walker"
    ),
    address = c(
      "14 Rose Cottage St.\nKenning UK, 323232",
      "14 Rose Cottage Blvd.\nKenning UK 34243", 
      "243 Hill St.\nGuthrie OK 73402",
      "342 Elm\nDuncanville TX, 75116",
      "Hotel Suite\nNew Orleans LA, 70115"
    ),
    telephone = c(
      "(405) 321-1111",
      "(405) 321-2222",
      "(405) 321-3333",
      "(405) 321-4444",
      "(405) 321-5555"
    ),
    email = c(
      "nutty@mouse.com",
      "tummy@mouse.comm",
      "mw@mwood.net",
      "peroxide@blonde.com",
      "left@hippocket.com"
    ),
    dob = c(12294, 12121, -13051, -6269, -5375),
    age = c(11, 11, 80, 61, 59),
    sex = c("Female", "Male", "Male", "Female", "Male"),
    demographics_complete = c(
      "Complete", "Complete", "Complete", "Complete", "Complete"
    )
  ),
  class = "data.frame",
  row.names = c(NA, -5L)
)

######  Tests  ######

test_that("column attributes are removed for df", {
  expect_equal(
    drop_labels(original), target
  )
})

test_that("data frames are required input", {
  expect_error(
    drop_labels(original[, 2]), "df must have class data.frame"
  )
})

test_that("df classes are preserved after labels are dropped ", {
  expect_equal(
    original |>
      dplyr::select("name_first") |>
      drop_labels() |>
      class(),
    "data.frame"
  )
})


