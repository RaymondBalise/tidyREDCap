# Count The Responses to a Choose All That Apply Question

This will tally the number of responses on a choose all that apply
question. This function extracts the option name from the variable
labels. So the data set needs to be labeled. See the [Make a 'Choose
All'
Table](https://raymondbalise.github.io/tidyREDCap/doc/makeChooseAllTable.md)
vignette for help.

## Usage

``` r
make_choose_all_table(df, variable)
```

## Arguments

- df:

  The name of the data set (it needs labels)

- variable:

  The name of the REDCap variable

## Value

A variable's response label without the choose all the question
