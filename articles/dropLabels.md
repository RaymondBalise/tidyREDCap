# Drop Labels from a Table

``` r
library(tidyREDCap)
```

## The Problem

The `tidyREDCap` package creates data sets with labelled columns.

``` r
tidyREDCap::import_instruments(
  url = "https://bbmc.ouhsc.edu/redcap/api/",
  token = keyring::key_get("REDCapR_test")
)
```

If you would like to see the labels on the data set `demographics`, you
can use the RStudio function
[`View()`](https://rdrr.io/r/utils/View.html), as shown below.

``` r
View(demographics)
```

![Demographics preview with labels](view_demog_w_labels_20230217.png)

However, some functions do not work well with labeled variables.

``` r
library(skimr)  # for the skim() function
demographics |> skim()
```

|                                                  |              |
|:-------------------------------------------------|:-------------|
| Name                                             | demographics |
| Number of rows                                   | 5            |
| Number of columns                                | 10           |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |              |
| Column type frequency:                           |              |
| character                                        | 7            |
| Date                                             | 1            |
| numeric                                          | 2            |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |              |
| Group variables                                  | None         |

Data summary

**Variable type: character**

| skim_variable         | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:----------------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| name_first            |         0 |             1 |   5 |   8 |     0 |        5 |          0 |
| name_last             |         0 |             1 |   3 |   8 |     0 |        4 |          0 |
| address               |         0 |             1 |  29 |  38 |     0 |        5 |          0 |
| telephone             |         0 |             1 |  14 |  14 |     0 |        5 |          0 |
| email                 |         0 |             1 |  12 |  19 |     0 |        5 |          0 |
| sex                   |         0 |             1 |   4 |   6 |     0 |        2 |          0 |
| demographics_complete |         0 |             1 |   8 |   8 |     0 |        1 |          0 |

**Variable type: Date**

| skim_variable | n_missing | complete_rate | min        | max        | median     | n_unique |
|:--------------|----------:|--------------:|:-----------|:-----------|:-----------|---------:|
| dob           |         0 |             1 | 1934-04-09 | 2003-08-30 | 1955-04-15 |        5 |

**Variable type: numeric**

| skim_variable | n_missing | complete_rate | mean |    sd |  p0 | p25 | p50 | p75 | p100 | hist  |
|:--------------|----------:|--------------:|-----:|------:|----:|----:|----:|----:|-----:|:------|
| record_id     |         0 |             1 |  3.0 |  1.58 |   1 |   2 |   3 |   4 |    5 | ▇▇▇▇▇ |
| age           |         0 |             1 | 44.4 | 31.57 |  11 |  11 |  59 |  61 |   80 | ▇▁▁▇▃ |

So you need a way to drop the label off of a variable or to drop all the
labels from all the variables in a dataset.

## The Solution

You can drop the label from a single variable with the
[`drop_label()`](https://raymondbalise.github.io/tidyREDCap/reference/drop_label.md)
function. For example:

``` r
demographics_changed <- drop_label(demographics, "name_first")
```

You can drop all the labels using the
[`drop_labels()`](https://raymondbalise.github.io/tidyREDCap/reference/drop_labels.md)
function. For example:

``` r
demographics_without_labels <- drop_labels(demographics)

demographics_without_labels |> 
  skim()
```

|                                                  |                            |
|:-------------------------------------------------|:---------------------------|
| Name                                             | demographics_without_labe… |
| Number of rows                                   | 5                          |
| Number of columns                                | 10                         |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |                            |
| Column type frequency:                           |                            |
| character                                        | 7                          |
| numeric                                          | 3                          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |                            |
| Group variables                                  | None                       |

Data summary

**Variable type: character**

| skim_variable         | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:----------------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| name_first            |         0 |             1 |   5 |   8 |     0 |        5 |          0 |
| name_last             |         0 |             1 |   3 |   8 |     0 |        4 |          0 |
| address               |         0 |             1 |  29 |  38 |     0 |        5 |          0 |
| telephone             |         0 |             1 |  14 |  14 |     0 |        5 |          0 |
| email                 |         0 |             1 |  12 |  19 |     0 |        5 |          0 |
| sex                   |         0 |             1 |   4 |   6 |     0 |        2 |          0 |
| demographics_complete |         0 |             1 |   8 |   8 |     0 |        1 |          0 |

**Variable type: numeric**

| skim_variable | n_missing | complete_rate |  mean |       sd |     p0 |   p25 |   p50 |   p75 |  p100 | hist  |
|:--------------|----------:|--------------:|------:|---------:|-------:|------:|------:|------:|------:|:------|
| record_id     |         0 |             1 |   3.0 |     1.58 |      1 |     2 |     3 |     4 |     5 | ▇▇▇▇▇ |
| dob           |         0 |             1 | -56.0 | 11581.94 | -13051 | -6269 | -5375 | 12121 | 12294 | ▃▇▁▁▇ |
| age           |         0 |             1 |  44.4 |    31.57 |     11 |    11 |    59 |    61 |    80 | ▇▁▁▇▃ |
