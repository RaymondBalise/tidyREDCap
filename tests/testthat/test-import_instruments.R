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
  if (packageVersion("REDCapR") <= "1.1.0") {
    expect_equal(demographics, target, ignore_attr = TRUE)
  } else {
    expect_equal(demographics, target)
  }
})

