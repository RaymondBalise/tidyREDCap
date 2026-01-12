# Changelog

## tidyREDCap 1.1.3 (CRAN release)

- Update vignettes to suggest `keyring`.
- Package now depends on R \>= 4.1.0 for use of pipe operator.
- Fixed vignette URLs that were causing site redirection issues with
  automated CRAN checks.
- Added alt text to vignette images.

## tidyREDCap 1.1.2 (CRAN release)

CRAN release: 2024-09-16

- Fix issues reported by CRAN with Linux and old R Windows (4.3.3)
  saying

&nbsp;

    ✖ These names are duplicated:
        * "record_id" at locations 1 and 2.

- Update roxygen2 version (Thank you for Will Beasley)
- Fix .data\$ was depreciated in `tidyselect`
  (<https://github.com/r-lib/tidyselect/issues/169>)
- Fixed missing global bindings caused by `tidyselect` fix.

## tidyREDCap 1.1.1 (CRAN release)

CRAN release: 2023-05-29

### New features

- Add
  [`make_yes_no()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no.md)
  function to convert “checked” or “yes”-like answers to “Yes” and other
  answers to “No or Unknown”.
- Add
  [`make_yes_no_unknown()`](https://raymondbalise.github.io/tidyREDCap/reference/make_yes_no_unknown.md)
  function to convert “checked” or “yes”-like answers to “Yes”,
  unchecked or “no”-like answers to “No” and other answers to “Unknown”.

### Fixes/Changes

- [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
  now works with api or manual/point-and-click exports. \## Added S3
  methods so dplyr (and friends) can work with labelled objects

## tidyREDCap 1.1.0 (CRAN release)

CRAN release: 2023-02-18

### New features

- Add
  [`drop_labels()`](https://raymondbalise.github.io/tidyREDCap/reference/drop_labels.md)
  function for datasets. Used to deal with packages/functions that don’t
  want labeled variables (i.e. `dplyr::pivot_longer()` and
  [`skimr::skim()`](https://docs.ropensci.org/skimr/reference/skim.html)
- Added options (`record_id =` and `first_record_id =` for custom
  record_id fields in
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
- Added repeat instance numbers for repeated instruments in
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)

### Fixes/Changes

- Documentation fixes
  - Suppress warning caused by dplyr 1.1
  - fix wrong function in api vignette

### Minor improvements and fixes

- Add unit test on import_instruments() function call.

## tidyREDCap 1.0.1.9001 (dev version)

### Fixes/Changes

- Fixed bug that caused labels to be missing if they contained
  parentheses

## tidyREDCap 1.0.1.9000 (dev version)

### New features

- Add drop label function

### Fixes/Changes

- Fix message display bug while
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  runs
- Fix bug with
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  loading repeated instruments (the first instrument in a project was
  badly messed up)
- Row names no longer reflect the row number of the exported data
- Remove labels from a few automatically created REDCap variables
  (“record_id”, “redcap_event_name”, “redcap_repeat_instrument”,
  “redcap_repeat_instance”)

## tidyREDCap 1.0.1 (CRAN release)

CRAN release: 2022-10-05

### New features

- Added support for REDCapR API
  - [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
    function imports all instruments with a single command
  - Added targeted status messaging during the import

### Minor improvements and fixes

- [`make_choose_one_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_one_table.md)
  no longer requires factors
- [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
  now works with “1” vs “0” indicator variables
- Greatly improved vignettes

## tidyREDCap 1.0.0.9002 (dev version)

- Add {REDCapR} support
- Added
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  function to import all instruments; currently uses the `REDCapR`
  package as the API

## tidyREDCap 1.0.0.9001 (dev version)

- Fix bug in
  [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
  with repeating instruments showing NA counts
- Removes superseded
  [`summarise_all()`](https://dplyr.tidyverse.org/reference/summarise_all.html)
  function

## tidyREDCap 1.0.0.9000 (dev version)

- Removes superseded `mutate_if` and `mutate_all` from
  [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
- Added
  [`import_instruments()`](https://raymondbalise.github.io/tidyREDCap/reference/import_instruments.md)
  function
- Added
  [`make_instrument_auto()`](https://raymondbalise.github.io/tidyREDCap/reference/make_instrument_auto.md)
  function
- Adds checks on arguments

## tidyREDCap 0.2.2 (CRAN patch)

CRAN release: 2022-01-30

- Fix `rlang` bug in
  [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md);
  see <https://github.com/RaymondBalise/tidyREDCap/pull/13>

## tidyREDCap 0.2.1 (CRAN release)

- Fix bug with “” character stings with make_instrument()

## tidyREDCap 0.2.0 (CRAN release)

CRAN release: 2020-02-10

- Cleaned up vignettes, docs

## tidyREDCap 0.1.3.1

- Cleaned up vignettes, docs

## tidyREDCap 0.1.3.0

- Added
  [`make_choose_all_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_all_table.md)
  function

## tidyREDCap 0.1.2.1

- Cleaned up vignettes

## tidyREDCap 0.1.2

- Added
  [`make_instrument()`](https://raymondbalise.github.io/tidyREDCap/reference/make_instrument.md)
  function

## tidyREDCap 0.1.1

- Added
  [`make_choose_one_table()`](https://raymondbalise.github.io/tidyREDCap/reference/make_choose_one_table.md)
  function

## tidyREDCap 0.1.0 (CRAN release)

CRAN release: 2020-01-13

- Fixed title capitalization.
- Added reference to REDCap website.
- Updated the release year in the license.
- Updated hyperlinks to vignettes and example instrument description.
- Added references to financial support in the ReadMe.

## tidyREDCap 0.0.0.9005

- Added check on number of arguments

## tidyREDCap 0.0.0.9004

- Added a `NEWS.md` file to track changes to the package.
