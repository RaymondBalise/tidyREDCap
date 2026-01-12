# Make a frequency table for a categorical variable

Pass this function either 1) a labeled factor or 2) a data frame and
also a factor in the frame, and it will return a `janitor`-style table.
Use subset = TRUE if you are making a report on a variable that is part
of a *choose all that apply* question.

## Usage

``` r
make_choose_one_table(arg1, arg2, subset = FALSE)
```

## Arguments

- arg1:

  data frame that has a factor or a factor name

- arg2:

  if arg1 is a data frame, this is a factor name

- subset:

  can be equal to TRUE/FALSE. This option removes extra variable name
  text from the label. This option is useful for *choose all that apply*
  questions.

## Value

a table
