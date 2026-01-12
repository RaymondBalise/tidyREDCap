# tidyREDCap

[![CRAN
status](https://www.r-pkg.org/badges/version/tidyREDCap)](https://CRAN.R-project.org/package=tidyREDCap)
[![Lifecycle:
maturing](https://lifecycle.r-lib.org/articles/figures/lifecycle-stable.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/tidyREDCap)](https://www.r-pkg.org/pkg/tidyREDCap)

tidyREDCap is an R package with functions for processing REDCap data.

‘REDCap’ (Research Electronic Data CAPture; <https://projectredcap.org>)
is a web-enabled application for building and managing surveys and
databases developed at Vanderbilt University.

## What tidyREDCap Functions Can Do for You?

#### Load All Data from REDCap into R with One Line of Code

- 💥 NEW in Version 1.1 💥
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  includes the repeat number for repeated
  instruments/forms/questionnaires.

- [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  will use an API call to load every instrument/questionnaire into its
  own R dataset. If the REDCap project is longitudinal or has repeated
  instruments, the function will remove blank records.

#### Show the Field Labels Inside RStudio

- After loading data into R using RStudio with the
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  function, you can see both the variable name and the text that appears
  to users of REDCap. All you need to do is click on the dataset’s name
  in the **Environment** tab or use the
  [`View()`](https://rdrr.io/r/utils/View.html) function. The column
  headings will include both the Variable Name and the Field Label from
  REDCap.

- 💥 NEW in Version 1.1 💥 Functions coming from packages outside of
  `tidyREDCap` may not understand what to do with labeled variables. So,
  `tidyREDCap` includes a new
  [`drop_labels()`](https://raymondbalise.github.io/tidyREDCap/reference/drop_labels.md)
  function that will allow you to strip the labels before using
  functions that want unlabeled data.

#### Working with *Choose One* Questions

- [`make_choose_one_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_one_table.md):
  print a
  [`janitor::tabyl()`](https://sfirke.github.io/janitor/reference/tabyl.html)
  style table with a variable label. This function lets you print one
  choice from a *choose all that apply* question.

#### Working with *Choose All that Apply* Questions

REDCap exports the responses to a *choose all that apply* question into
many similarly named questions. tidyREDCap helps summarize the responses
with two functions:

- [`make_binary_word()`](https://raymondbalise.github.io/tidyREDCap/reference/make_binary_word.md):
  converts all the responses into a single descriptive “word”
- [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md):
  converts all the responses into a single summary table

#### Working with Repeated Measures

Projects that have repeated assessments with different
questionnaires/instruments export with holes in the CSV. tidyREDCap will
parse the export and create tables for any of the
questionnaires/instruments:

- [`make_instrument()`](https://raymondbalise.github.io/tidyREDCap/reference/make_instrument.md):
  makes a tibble for a questionnaire/instrument

## What are the tidyREDCap Websites?

Main Page: <https://raymondbalise.github.io/tidyREDCap/>  
**User Guides**:
<https://raymondbalise.github.io/tidyREDCap/articles/>  
Development Site: <https://github.com/RaymondBalise/tidyREDCap>

## Where Can I Find tidyREDCap?

#### Offical Release

You can get the latest official release of tidyREDCap from CRAN.

    install.packages("tidyREDCap")

#### Development Release

Run these two lines of code to install tidyREDCap from GitHub (this
requires [RTools](https://cran.r-project.org/bin/windows/Rtools/) for
Windows or Xcode for Mac to be installed on your computer):

    if (!requireNamespace("devtools")) install.packages("devtools")
    devtools::install_github("RaymondBalise/tidyREDCap")

#### What is new on the development release?

- 💥 NEW in Version 1.1.0.9000 💥 adds
  [`make_yes_no()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no.md)
  function to convert “checked” or “yes”-like answers to “Yes” and other
  answers to “No or Unknown”.
- 💥 NEW in Version 1.1.0.9000 💥 adds
  [`make_yes_no_unknown()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no_unknown.md)
  function to convert “checked” or “yes”-like answers to “Yes”“,
  unchecked or”no”-like answers to “No” and other answers to “Unknown”.

## What if I Find a Problem?

We are currently in active development of tidyREDCap. If one of our
functions does not work the way that you expect, or if one of our
functions is broken, please submit an issue ticket (using a
[reproducible
example](https://reprex.tidyverse.org/articles/reprex-dos-and-donts.html))
to our [issues
page](https://github.com/RaymondBalise/tidyREDCap/issues). If you have a
cool idea for our next new function, also submit an issue ticket. If you
are an R developer and want so contribute to this package, please submit
an issue ticket or a pull request.

## Who Are Our Supporters?

The development of this package was supported by:

- Healing Communities Study: Developing and Testing and Integrated
  Approach to Address the Opioid Crisis-New York State.
  - National Institute on Drug Abuse, 1 UM1 DA049415
- CTN-0094 Individual Level Predictive Modeling of Opioid Use Disorder
  Treatment Outcome.
  - Florida Node Alliance Of The Drug Abuse Clinical Trials Network NIDA
    UG1 DA013720
- University of Miami Center for HIV and Researching Mental Health
  (CHARM)
  - NIH 1P30MH116867-01A1
- University of Miami, Sylvester Comprehensive Cancer Center
- Florida International University, Stempel College of Public Health
