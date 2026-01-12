# Extract an Instrument from an REDCap Export without specifying Variables

This function takes a data frame holding REDCap data, checks if it is a
longitudinal study, and returns records that have values.

## Usage

``` r
make_instrument_auto(df, drop_which_when = FALSE, record_id = "record_id")
```

## Arguments

- df:

  A data frame with the instrument

- drop_which_when:

  Drop the `record_id` and `redcap_event_name` variables

- record_id:

  Name of `record_id` variable (if it was changed in REDCap)

## Value

A data frame that has an instrument (with at least one not NA value).
