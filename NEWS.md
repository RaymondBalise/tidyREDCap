# tidyREDCap 1.0.1  (CRAN release)

## New features

* Added support for REDCapR API
  - `import_instruments()` function imports all instruments with a single command
  - Added targeted status messaging during the import
  
## Minor improvements and fixes

* `make_choose_one_table()` no longer requires factors
* `make_choose_all_table()` now works with "1" vs "0" indiator variables
* added status messaging during the import
* Greatly improved vignettes

# tidyREDCap 1.0.0.9002  (dev version)

* Add {REDCapR} support
* Added `import_instruments()` function to import all instruments; currently uses the `REDCapR` package as the API


# tidyREDCap 1.0.0.9001  (dev version)

* Fix bug in `make_choose_all_table()` with repeating instruments showing NA counts
* Removes superseded `summarise_all()` function

# tidyREDCap 1.0.0.9000  (dev version)

* Removes superseded `mutate_if` and `mutate_all` from `make_choose_all_table()`
* Added `import_instruments()` function
* Added `make_instrument_auto()` function
* Adds checks on arguments

# tidyREDCap 0.2.2  (CRAN patch)

* Fix `rlang` bug in `make_choose_all_table()`; see <https://github.com/RaymondBalise/tidyREDCap/pull/13>

# tidyREDCap 0.2.1  (CRAN release)

* Fix bug with "" character stings with make_instrument()

# tidyREDCap 0.2.0 (CRAN release)

* Cleaned up vignettes, docs

# tidyREDCap 0.1.3.1 

* Cleaned up vignettes, docs

# tidyREDCap 0.1.3.0 

* Added `make_choose_all_table()` function

# tidyREDCap 0.1.2.1 

* Cleaned up vignettes

# tidyREDCap 0.1.2 

* Added `make_instrument()` function

# tidyREDCap 0.1.1

* Added `make_choose_one_table()` function

# tidyREDCap 0.1.0 (CRAN release)

* Fixed title capitalization.
* Added reference to REDCap website.
* Updated the release year in the license.
* Updated hyperlinks to vignettes and example instrument description.
* Added references to financial support in the ReadMe.

# tidyREDCap (development version)

# tidyREDCap 0.0.0.9005

* Added check on number of arguments

# tidyREDCap 0.0.0.9004

* Added a `NEWS.md` file to track changes to the package.


