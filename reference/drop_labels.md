# Drop all the labels from a variable

There is an issue with the function we are using to add column labels.
If you run into problems processing the labels.

## Usage

``` r
drop_labels(df)
```

## Arguments

- df:

  The data frame with column labels that you want to drop

## Value

df without column labels

## Examples

``` r
if (FALSE) { # \dontrun{
demographics |>
  drop_labels() |>
  skimr::skim()
} # }
```
