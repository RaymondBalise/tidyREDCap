  <!-- badges: start -->
  [![CRAN status](https://www.r-pkg.org/badges/version/tidyREDCap)](https://CRAN.R-project.org/package=tidyREDCap)
  [![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
  [![Travis build status](https://travis-ci.org/RaymondBalise/tidyREDCap.svg?branch=master)](https://travis-ci.org/RaymondBalise/tidyREDCap)
  <!-- badges: end -->

# tidyREDCap <a href='https://raymondbalise.github.io/tidyREDCap/'><img src='man/figures/logo.png' align="right" height="139" /></a>

tidyREDCap is an R package with functions for processing REDCap data. 

'REDCap' (Research Electronic Data CAPture; <https://projectredcap.org>) is a web-enabled application for building and managing surveys and databases developed at Vanderbilt University.

## What tidyREDCap Functions Can Do for You

### Working with <i>Choose One</i> Questions

* `make_choose_one_table()`: print a `janitor::tabyl()` style table with a variable label.  This function lets you print one choice from a <i>choose all that apply</i> question. 

### Working with <i>Choose All that Apply</i> Questions

REDCap exports the responses to a <i>choose all that apply</i> question into many similarly named questions.  tidyREDCap helps summarize the responses with two functions:

* `make_binary_word()`: converts all the responses into a single descriptive "word"
* `make_choose_all_table()`: converts all the responses into a single summary table

### Working with Repeated Measures

Projects that have repeated assessments with different questionnaires/instruments export with holes in the CSV.  tidyREDCap will parse the export and create tables for any of the questionnaires/instruments:

* `make_instrument()`: makes a tibble for a questionnaire/instrument

## Websites
https://raymondbalise.github.io/tidyREDCap/

https://github.com/RaymondBalise/tidyREDCap

## Our Supporters
The development of this package was supported by:

* Healing Communities Study: Developing and Testing and Integrated Approach to Address the Opioid Crisis-New York State. 
    * National Institute on Drug Abuse, 1 UM1 DA049415
* CTN-0094 Individual Level Predictive Modeling of Opioid Use Disorder Treatment Outcome.  
    * Florida Node Alliance Of The Drug Abuse Clinical Trials Network  NIDA UG1 DA013720
* University of Miami Center for HIV and Researching Mental Health (CHARM)
    * NIH	1P30MH116867-01A1
* University of Miami, Sylvester Comprehensive Cancer Center