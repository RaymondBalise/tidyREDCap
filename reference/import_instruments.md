# Import all instruments into individual R tables

This function takes the url and key for a REDCap project and returns a
table for each instrument/form in the project.

## Usage

``` r
import_instruments(
  url,
  token,
  drop_blank = TRUE,
  record_id = "record_id",
  first_record_id = 1,
  envir = .GlobalEnv
)
```

## Arguments

- url:

  The API URL for your the instance of REDCap

- token:

  The API security token

- drop_blank:

  Drop records that have no data. TRUE by default.

- record_id:

  Name of `record_id` variable (if it was changed in REDCap).

- first_record_id:

  A value of the custom `record_id` variable (if changed in REDCap). To
  improve the speed of the import, tidyREDCap pulls in a single record
  twice. By default if uses the first record. If you have a custom
  `record_id` variable and if its the first record identifier is not
  `1`, specify a record identifier value here. For example if you are
  using `dude_id` instead of `record_id` and `dude_id` has a value of
  "first dude" for one of its records this argument would be
  `first_record_id = "first dude"`.

- envir:

  The name of the environment where the tables should be saved.

## Value

one `data.frame` for each instrument/form in a REDCap project. By
default the datasets are saved into the global environment.

## Examples

``` r
if (FALSE) { # \dontrun{
import_instruments(
  "https://redcap.miami.edu/api/",
  keyring::key_get("test_API_key")
)
} # }
```
