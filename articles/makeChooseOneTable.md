# Make a 'Choose One' Table

``` r
library(tidyREDCap)
```

## The Problem

It is often desirable to print variable labels above a summary table
that shows the count of factor labels. The labels exported on *choose
all that apply* questions, including the question and whichever response
was chosen. This redundancy is often unwanted, and the results are not
presented professionally.

For example, in the Nacho Craving Index data, the first ingredient is
“Chips”. We see how R presents this information by simply printing the
components of the `ingredients___1` column.

``` r
redcap <- readRDS(file = "./redcap.rds")
redcap$ingredients___1
# What ingredients do you currently crave?: Chips
#  [1] Checked   Checked   Unchecked Unchecked Unchecked Unchecked Checked  
#  [8] Unchecked Unchecked Unchecked Unchecked Unchecked Checked   Unchecked
# [15] Unchecked Checked   Unchecked Unchecked Checked   Unchecked Unchecked
# [22] Unchecked Checked   Unchecked Checked   Unchecked Unchecked Unchecked
# [29] Unchecked Checked  
# attr(,"redcapLabels")
# [1] Unchecked Checked  
# attr(,"redcapLevels")
# [1] 0 1
# Levels: Unchecked Checked
```

As we can see, this information is quite ugly, so we want to tabulate
the results instead. However, if we use the simple
[`table()`](https://rdrr.io/r/base/table.html) function to clean up this
information, we lose the original question and the answer label for
`ingredients___1`.

``` r
table(redcap$ingredients___1)
# 
# Unchecked   Checked 
#        21         9
```

We no longer know what the question was or which “select all” option
this information represents.

### Aside: Loading REDCap Data into R

See the [Import All Instruments from a REDCap
Project](https://raymondbalise.github.io/tidyREDCap/articles/import_instruments.md)
and [Importing from
REDCap](https://raymondbalise.github.io/tidyREDCap/articles/useAPI.md)
vignettes for details/information.

## The Solution

The
[`make_choose_one_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_one_table.md)
function can be used with a factor variable to tabulate the response
*while preserving the question and checked option context*.

``` r
make_choose_one_table(redcap$ingredients___1) 
# What ingredients do you currently crave?: Chips
#   Response  n percent
#  Unchecked 21     70%
#    Checked  9     30%
```

Further, this output can be molded into a publication-ready table with a
single additional function call.

``` r
make_choose_one_table(redcap$ingredients___1) %>% 
  knitr::kable()
```

What ingredients do you currently crave?: Chips

| Response  |   n | percent |
|:----------|----:|:--------|
| Unchecked |  21 | 70%     |
| Checked   |   9 | 30%     |

The `subset` option, if set to `TRUE,` will cause the function to remove
the label’s text and only show the response option (i.e., not repeat the
“What ingredients do you currently crave?” question).

``` r
make_choose_one_table(
  redcap$ingredients___2,
  subset = TRUE
) %>% 
  knitr::kable()
```

Yellow cheese

| Response  |   n | percent |
|:----------|----:|:--------|
| Unchecked |  23 | 77%     |
| Checked   |   7 | 23%     |

This function can also be used in an analysis pipeline with a data frame
name and the name of the factor inside that data frame. For example:

``` r
redcap %>% 
  make_choose_one_table(ingredients___3) %>% 
  knitr::kable() 
```

What ingredients do you currently crave?: Orange cheese

| Response  |   n | percent |
|:----------|----:|:--------|
| Unchecked |  27 | 90%     |
| Checked   |   3 | 10%     |
