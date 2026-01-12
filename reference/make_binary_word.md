# Convert a "choose all that apply" Question Into a Binary Word

This function takes a data frame holding binary variables with values
corresponding to a dummy-coded "choose all that apply" question. It can
be used for any *binary word* problem.

## Usage

``` r
make_binary_word(df, yes_value = "Checked", the_labels = letters)
```

## Arguments

- df:

  A data frame with the variables corresponding to binary indicators
  (the dummy coded variables) for a "choose all that apply" question.

- yes_value:

  A character string that corresponds to choosing "yes" in the binary
  variables of `df`. Defaults to the REDCap "Checked" option.

- the_labels:

  A character vector of single letters holding the letters used to make
  the binary word. See the article/vignette called "Make Binary Word"
  for an example:
  <https://raymondbalise.github.io/tidyREDCap/articles/makeBinaryWord.html>.

## Value

A character vector with length equal to the rows of `df`, including one
letter or underscore for each column of `df`. For instance, if `df` has
one column for each of the eight options of the Nacho Craving Index
example instrument
(<https://libguides.du.edu/c.php?g=948419&p=6839916>), with a row
containing the values "Chips" (checked), "Yellow cheese" (unchecked),
"Orange cheese" (checked), "White cheese" (checked), "Meat" (checked),
"Beans" (unchecked), "Tomatoes" (unchecked) and "Peppers" (checked),
then the character string corresponding to that row will be
`"a_cde__h"`. The underscores represent that the options for "Yellow
cheese", "Beans", and "Tomatoes" were left unchecked.

## Examples

``` r
test_df <- tibble::tibble(
  q1 = c("Unchecked", "Checked"),
  q2 = c("Unchecked", "Unchecked"),
  q3 = c("Checked", "Checked"),
  q4 = c("Checked", "Unchecked")
)
make_binary_word(test_df)
#> [1] "__cd" "a_c_"
```
