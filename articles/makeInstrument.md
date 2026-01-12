# Make an Instrument

``` r
library(tidyREDCap)
library(dplyr)
```

## The Problem

REDCap exports longitudinal projects with one record (a line of data)
per assessment (typically 1 line per day). This works well when every
instrument/questionnaire is given at every assessment. Still, for
projects with different instruments/questionnaires given on different
days, REDCap exports empty values (represented by the value `NA` in R).

> **Example:** In the Nachos for Anxiety project, three instruments were
> used; they each had a different administration schedule. Subjects’
> anxiety was assessed at baseline with the Generalized Anxiety Disorder
> 7-item (GAD-7) scale. Every day, it was assessed with the Hamilton
> Anxiety Scale (HAM-A), but the Nacho Craving Index was administered
> only at the baseline and at the end of the study (see the figure below
> for clarification).  
> ![Nacho Craving Index administration schedule](schedule.png)

The instruments that are not assessed every day appear as entirely blank
questionnaires when the data is exported. For example, values from the
NCI instrument are shown as missing for Day 1, Day 2, and Day 3 (because
it was not administered during those visits).

In R, this data is displayed as

``` r
redcap <- readRDS(file = "./redcap_nacho_anxiety.rds")

redcap %>% 
  select(
    # Select these two columns
    record_id, redcap_event_name,
    # And also select all columns between "nachos" and "nci_complete"
    nachos:nci_complete
  ) %>% 
  # Make the table pretty
  knitr::kable()
```

| record_id | redcap_event_name | nachos | treat | treating | othercondition | last                           | traveled | miles | now | strong | ingredients\_\_\_1 | ingredients\_\_\_2 | ingredients\_\_\_3 | ingredients\_\_\_4 | ingredients\_\_\_5 | ingredients\_\_\_6 | ingredients\_\_\_7 | ingredients\_\_\_8 | cheese    | crunch    | bean      | guacamole | jalapeno  | meat      | life                           | nci_complete |
|:----------|:------------------|:-------|:------|:---------|:---------------|:-------------------------------|:---------|------:|:----|-------:|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:----------|:----------|:----------|:----------|:----------|:----------|:-------------------------------|:-------------|
| 1         | baseline_arm_1    | Yes    | TRUE  | Other    | Anxiety        | I ate nachos in the last year. | Yes      |  3115 | Yes |     74 | Checked            | Checked            | Unchecked          | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They helped me cure my hunger. | Complete     |
| 1         | day_1_arm_1       | NA     | NA    | NA       | NA             | NA                             | NA       |    NA | NA  |     NA | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA        | NA        | NA        | NA        | NA        | NA        | NA                             | NA           |
| 1         | day_2_arm_1       | NA     | NA    | NA       | NA             | NA                             | NA       |    NA | NA  |     NA | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA        | NA        | NA        | NA        | NA        | NA        | NA                             | NA           |
| 1         | day_3_arm_1       | NA     | NA    | NA       | NA             | NA                             | NA       |    NA | NA  |     NA | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA                 | NA        | NA        | NA        | NA        | NA        | NA        | NA                             | NA           |
| 1         | end_arm_1         | Yes    | TRUE  | Other    | Anxiety        | I am currently eating nachos.  | Yes      |  3115 | Yes |     90 | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They make me feel happy.       | Complete     |

It is often helpful to make a different data table that has the values
for each questionnaire without the blank records.

### Aside: Loading REDCap Data into R

See the [Import All Instruments from a REDCap
Project](https://raymondbalise.github.io/tidyREDCap/articles/import_instruments.md)
and [Importing from
REDCap](https://raymondbalise.github.io/tidyREDCap/articles/useAPI.md)
vignettes for details/information.

## The Solution

Pass the
[`make_instrument()`](https://raymondbalise.github.io/tidyREDCap/reference/make_instrument.md)
function to the name of a dataset and the names of the first and last
variables in an instrument, and it will return a table that has the
non-empty records for the instrument. For example, to extract the
enrollment/consent instrument:

``` r
make_instrument(redcap, "concented", "enrollment_complete") %>% 
  knitr::kable()
```

| record_id | redcap_event_name | concented | enrollment_complete |
|:----------|:------------------|:----------|:--------------------|
| 1         | baseline_arm_1    | Yes       | Complete            |

To extract nacho craving information:

``` r
make_instrument(redcap, "nachos", "nci_complete") %>% 
  knitr::kable()
```

|     | record_id | redcap_event_name | nachos | treat | treating | othercondition | last                           | traveled | miles | now | strong | ingredients\_\_\_1 | ingredients\_\_\_2 | ingredients\_\_\_3 | ingredients\_\_\_4 | ingredients\_\_\_5 | ingredients\_\_\_6 | ingredients\_\_\_7 | ingredients\_\_\_8 | cheese    | crunch    | bean      | guacamole | jalapeno  | meat      | life                           | nci_complete |
|:----|:----------|:------------------|:-------|:------|:---------|:---------------|:-------------------------------|:---------|------:|:----|-------:|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:----------|:----------|:----------|:----------|:----------|:----------|:-------------------------------|:-------------|
| 1   | 1         | baseline_arm_1    | Yes    | TRUE  | Other    | Anxiety        | I ate nachos in the last year. | Yes      |  3115 | Yes |     74 | Checked            | Checked            | Unchecked          | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They helped me cure my hunger. | Complete     |
| 5   | 1         | end_arm_1         | Yes    | TRUE  | Other    | Anxiety        | I am currently eating nachos.  | Yes      |  3115 | Yes |     90 | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They make me feel happy.       | Complete     |

To make an analysis dataset containing the NCI values **without** the
subject ID and the event name:

``` r
make_instrument(
  redcap,
  "nachos", "nci_complete",
  drop_which_when = TRUE
) %>% 
  knitr::kable()
```

|     | nachos | treat | treating | othercondition | last                           | traveled | miles | now | strong | ingredients\_\_\_1 | ingredients\_\_\_2 | ingredients\_\_\_3 | ingredients\_\_\_4 | ingredients\_\_\_5 | ingredients\_\_\_6 | ingredients\_\_\_7 | ingredients\_\_\_8 | cheese    | crunch    | bean      | guacamole | jalapeno  | meat      | life                           | nci_complete |
|:----|:-------|:------|:---------|:---------------|:-------------------------------|:---------|------:|:----|-------:|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:-------------------|:----------|:----------|:----------|:----------|:----------|:----------|:-------------------------------|:-------------|
| 1   | Yes    | TRUE  | Other    | Anxiety        | I ate nachos in the last year. | Yes      |  3115 | Yes |     74 | Checked            | Checked            | Unchecked          | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They helped me cure my hunger. | Complete     |
| 5   | Yes    | TRUE  | Other    | Anxiety        | I am currently eating nachos.  | Yes      |  3115 | Yes |     90 | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | Checked            | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | 5 Love it | They make me feel happy.       | Complete     |
