# Extract an Instrument from an REDCap Export

This function takes a data frame and the names of the first and last
variables in an instrumnt and returns a data frame with the instrument.

## Usage

``` r
make_instrument(
  df,
  first_var,
  last_var,
  drop_which_when = FALSE,
  record_id = "record_id"
)
```

## Arguments

- df:

  A data frame with the instrument

- first_var:

  The name of the first variable in an instrument

- last_var:

  The name of the last variable in an instrument

- drop_which_when:

  Drop the `record_id` and `redcap_event_name` variables

- record_id:

  Name of `record_id` variable (if it was changed in REDCap)

## Value

A data frame that has an instrument (with at least one not NA value)
