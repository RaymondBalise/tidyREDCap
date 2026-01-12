# make_yes_no_unknown

Convert a "Yes-No", "True-False" or "Checkboxes (Multiple Answers)"
question in REDCap to a factor holding "No" or "Yes" or "Unknown".
Technically "yes" or "checked" (ignoring case), 1 or TRUE responses are
converted to "Yes". "No" or "unchecked" (ignoring case), 0 or FALSE are
converted to "No". All other values are set to "Unknown". Also see
[`make_yes_no()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no.md).

## Usage

``` r
make_yes_no_unknown(x)
```

## Arguments

- x:

  variable to be converted to hold "No", "Yes", or Unknown"

## Value

a factor with "No", "Yes", or Unknown"

## Examples

``` r
make_yes_no_unknown(c(0, 1, NA))
#> [1] No      Yes     Unknown
#> Levels: No Yes Unknown
make_yes_no_unknown(c("unchecked", "Checked", NA))
#> [1] No      Yes     Unknown
#> Levels: No Yes Unknown
```
