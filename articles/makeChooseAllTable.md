# Make a 'Choose All' Table

``` r
library(tidyREDCap)
library(dplyr)
```

## The Problem

REDCap exports a “choose all that apply” question into a series of
similarly-named, binary indicator variables (i.e., the variables are
equal to either “checked” or “unchecked”). For example, the following
data represents a sample of responses to the Nacho Craving Index.

``` r
redcap <- readRDS(file = "./redcap.rds")
redcap %>% 
  select(starts_with("ingredients___")) %>% 
  head()
#>   ingredients___1 ingredients___2 ingredients___3 ingredients___4
#> 1         Checked         Checked         Checked         Checked
#> 2         Checked         Checked       Unchecked         Checked
#> 3       Unchecked       Unchecked       Unchecked       Unchecked
#> 4       Unchecked       Unchecked       Unchecked       Unchecked
#> 5       Unchecked       Unchecked       Unchecked       Unchecked
#> 6       Unchecked       Unchecked       Unchecked       Unchecked
#>   ingredients___5 ingredients___6 ingredients___7 ingredients___8
#> 1         Checked         Checked       Unchecked         Checked
#> 2         Checked       Unchecked         Checked         Checked
#> 3       Unchecked       Unchecked       Unchecked       Unchecked
#> 4       Unchecked       Unchecked       Unchecked       Unchecked
#> 5       Unchecked       Unchecked       Unchecked       Unchecked
#> 6       Unchecked       Unchecked       Unchecked       Unchecked
```

It is desirable to have a concise table showing how often each option
was chosen.

### Aside: Loading REDCap Data into R

See the [Import All Instruments from a REDCap
Project](https://raymondbalise.github.io/tidyREDCap/articles/import_instruments.md)
and [Importing from
REDCap](https://raymondbalise.github.io/tidyREDCap/articles/useAPI.md)
vignettes for details/information.

## The Solution

### Data Loaded with `import_instruments()`

If you pass the
[`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
function, the name of a REDCap export, and the name of the *choose all
that apply question* question in REDCap, it will produce a concise
frequency count table.

``` r
make_choose_all_table(redcap, "ingredients") 
#> # A tibble: 8 × 2
#>   What          Count
#>   <chr>         <dbl>
#> 1 Chips             9
#> 2 Yellow cheese     7
#> 3 Orange cheese     3
#> 4 White cheese      4
#> 5 Meat              5
#> 6 Beans             7
#> 7 Tomatoes          6
#> 8 Peppers           8
```

Similar to the
[`make_choose_one_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_one_table.md)
function, we can use this function inside an analysis pipeline. We can
add the `kable()` call to make the table publication quality.

``` r
redcap %>% 
  make_choose_all_table("ingredients") %>% 
  knitr::kable()
```

| What          | Count |
|:--------------|------:|
| Chips         |     9 |
| Yellow cheese |     7 |
| Orange cheese |     3 |
| White cheese  |     4 |
| Meat          |     5 |
| Beans         |     7 |
| Tomatoes      |     6 |
| Peppers       |     8 |

### Data Exported with “Data Exports, Reports and Stats” in REDCap

If you export data using the point-and-click tools built into REDCap you
end up with two files, one contains R code the other data. When you run
the code you end up with a dataset called `data` which contains two
copies of some of the information. For example, if you download the
Nacho Craving Index you will see the ingredients variables, showing what
ingredients people are craving, and a second copy of the variables that
have `.factor` tagged to the end of the names. The factor versions do
not have the variable labels. So you will need to subset the data to
drop them. The example below shows the process. Note we have copied the
`data` data frame to have a more meaningful name.

``` r
# This is the data produced by exporting using point-and-click REDCap export.
manual_export <- data

manual_export |>   
  select(starts_with("ingredient")) |> # get all the ingredient variables
  select(-ends_with(".factor")) |>     # drop the factor version of the ingredient variables
  make_choose_all_table("ingredient")  # make the table
```
