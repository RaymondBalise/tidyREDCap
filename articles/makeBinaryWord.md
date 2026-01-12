# Make Binary Word

``` r
library(tidyREDCap)
library(dplyr)
```

## The Problem

REDCap exports a “choose all that apply” question into a series of
similarly-named, binary indicator variables (i.e., the variables are
equal to either “checked” or “unchecked”). Using these variables
individually, there is no obvious way to detect common patterns people
pick together.

> **Example:** In the Nacho Craving Index (NCI), respondents can
> indicate which of eight ingredients they are currently craving (i.e.,
> Chips, Yellow cheese, Orange cheese, White cheese, Meat, Beans,
> Tomatoes, Peppers). These are exported into variables with names like
> `ingredients___1`, `ingredients___2`, etc.

In REDCap, it is simple to get a summary of those individual variables
by using the “Data Exports, Reports, and Stats” application within the
REDCap interface and selecting “Stats & Charts”. Once the data is in R,
simple tables can be produced with the
[`table()`](https://rdrr.io/r/base/table.html) function, or beautiful
tables can be created with the `tabyl()` and `adorn_pct_formatting()`
functions from the
[`janitor`](https://sfirke.github.io/janitor/index.html) package.
However, from these univariate tables, it is impossible to judge which
patterns of answers are marked together. In the above example, using the
univariate tables, it is difficult to tell what percentage of people are
craving both chips and yellow cheese.

``` r
redcap <- readRDS(file = "./redcap.rds")

# Chips
janitor::tabyl(redcap$ingredients___1) %>% 
  janitor::adorn_pct_formatting() %>% 
  knitr::kable()
```

| redcap\$ingredients\_\_\_1 |   n | percent |
|:---------------------------|----:|:--------|
| Unchecked                  |  21 | 70.0%   |
| Checked                    |   9 | 30.0%   |

``` r

# Yellow cheese
janitor::tabyl(redcap$ingredients___2) %>% 
  janitor::adorn_pct_formatting() %>% 
  knitr::kable()
```

| redcap\$ingredients\_\_\_2 |   n | percent |
|:---------------------------|----:|:--------|
| Unchecked                  |  23 | 76.7%   |
| Checked                    |   7 | 23.3%   |

### Aside: Loading REDCap Data into R

See the [Import All Instruments from a REDCap
Project](https://raymondbalise.github.io/tidyREDCap/articles/import_instruments.md)
and [Importing from
REDCap](https://raymondbalise.github.io/tidyREDCap/articles/useAPI.md)
vignettes for details/information.

## Make Analysis Data

Even after subsetting the REDCap data to only include the ingredients
variables, it is still difficult to detect common patterns in the eight
ingredients.

``` r
redcap <- readRDS(file = "./redcap.rds")

analysis <- redcap %>% 
  select(starts_with("ingredients___")) 
  
knitr::kable(tail(analysis))
```

|     | ingredients\_\_\_1 | ingredients\_\_\_2 | ingredients\_\_\_3 | ingredients\_\_\_4 | ingredients\_\_\_5 | ingredients\_\_\_6 | ingredients\_\_\_7 | ingredients\_\_\_8 |
|:----|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|
| 25  | Checked            | Checked            | Unchecked          | Unchecked          | Unchecked          | Checked            | Unchecked          | Unchecked          |
| 26  | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          |
| 27  | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          |
| 28  | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          |
| 29  | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Unchecked          |
| 30  | Checked            | Checked            | Unchecked          | Unchecked          | Unchecked          | Unchecked          | Checked            | Unchecked          |

## The Solution

### Default Lettering

The
[`make_binary_word()`](https://raymondbalise.github.io/tidyREDCap/reference/make_binary_word.md)
function combines responses from the individual variables into a single
“word” that indicates which choices were selected. For example, if the
first option from the NCI ingredient question, *chips* (i.e.,
`ingredients___1`), was checked, the word created by
[`make_binary_word()`](https://raymondbalise.github.io/tidyREDCap/reference/make_binary_word.md)
will begin with *a*; or if it was not checked, the word would start with
*\_*. If the second option, *Yellow cheese* (i.e., `ingredients___2`),
was checked, the next letter will be a *b*; otherwise, a *\_* will be
used as a placeholder. Following this pattern, if somebody is not
craving any of the eight nacho ingredients, the “word” will be eight
underscores, one for each ingredient (i.e., \_\_\_\_\_\_\_\_).
Conversely, if they are craving every ingredient, the “word” will be
*abcdefgh*.

``` r
patterns <- make_binary_word(analysis) 
janitor::tabyl(patterns)
#>  patterns  n    percent
#>  ________ 20 0.66666667
#>  ______gh  1 0.03333333
#>  a_c__f_h  1 0.03333333
#>  a_cdefgh  1 0.03333333
#>  ab____g_  1 0.03333333
#>  ab___f__  1 0.03333333
#>  ab___f_h  1 0.03333333
#>  ab__efgh  1 0.03333333
#>  ab_de_gh  1 0.03333333
#>  ab_defgh  1 0.03333333
#>  abcdef_h  1 0.03333333
```

### Custom Lettering

While the default lettering is somewhat helpful, using meaningful
(mnemonic) letters makes the binary words easier to understand. In this
case, the first letter for each choice can be used as a helpful
mnemonic.

| Abbreviation | Ingredient    |
|:-------------|:--------------|
| C            | Chips         |
| Y            | Yellow cheese |
| O            | Orange cheese |
| W            | White cheese  |
| M            | Meat          |
| B            | Beans         |
| T            | Tomatoes      |
| P            | Peppers       |

To use custom lettering, specify a vector of single-letter abbreviations
and pass it to the `the_labels` argument. Be sure to include one unique
abbreviation for each data frame column. For example:

``` r
labels <- c("C", "Y", "O", "W", "M", "B", "T", "P")

patterns <- make_binary_word(analysis, the_labels = labels)

janitor::tabyl(patterns)
#>  patterns  n    percent
#>  CYOWMB_P  1 0.03333333
#>  CY_WMBTP  1 0.03333333
#>  CY_WM_TP  1 0.03333333
#>  CY__MBTP  1 0.03333333
#>  CY___B_P  1 0.03333333
#>  CY___B__  1 0.03333333
#>  CY____T_  1 0.03333333
#>  C_OWMBTP  1 0.03333333
#>  C_O__B_P  1 0.03333333
#>  ______TP  1 0.03333333
#>  ________ 20 0.66666667
```

The summary table shows that 20 people did not provide information about
what ingredients they craved. The remaining people do not display any
recurring patterns, but many people craved chips and yellow cheese
together.
