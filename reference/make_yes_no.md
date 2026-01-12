# make_yes_no

Convert a "Yes-No", "True-False" or "Checkboxes (Multiple Answers)"
question in REDCap to a factor holding "Yes" or "No or Unknown".
Technically "yes" or "checked" (ignoring case), 1 or TRUE responses are
converted to "Yes" and all other values to "No or Unknown". Also see
[`make_yes_no_unknown()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no_unknown.md).

## Usage

``` r
make_yes_no(x)
```

## Arguments

- x:

  x variable to be converted to hold "Yes" or "No or Unknown"

## Value

a factor with "Yes" or "No or Unknown"

## Examples

``` r
make_yes_no(c(0, 1, NA))
#> [1] No or Unknown Yes           No or Unknown
#> Levels: No or Unknown Yes
make_yes_no(c("unchecked", "Checked", NA))
#> [1] No or Unknown Yes           No or Unknown
#> Levels: No or Unknown Yes
```
