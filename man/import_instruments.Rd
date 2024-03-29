% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_instruments.R
\name{import_instruments}
\alias{import_instruments}
\title{Import all instruments into individual R tables}
\usage{
import_instruments(
  url,
  token,
  drop_blank = TRUE,
  record_id = "record_id",
  first_record_id = 1,
  envir = .GlobalEnv
)
}
\arguments{
\item{url}{The API URL for your the instance of REDCap}

\item{token}{The API security token}

\item{drop_blank}{Drop records that have no data. TRUE by default.}

\item{record_id}{Name of \code{record_id} variable (if it was changed in REDCap).}

\item{first_record_id}{A value of the custom \code{record_id} variable (if
changed in REDCap).  To improve the speed of the import, tidyREDCap pulls
in a single record twice.  By default if uses the first record.  If you
have a custom \code{record_id} variable and if its the first record identifier
is not \code{1},  specify a record identifier value here.  For example if you
are using \code{dude_id} instead of \code{record_id} and \code{dude_id} has a value of
"first dude" for one of its records this argument would be
\code{first_record_id = "first dude"}.}

\item{envir}{The name of the environment where the tables should be saved.}
}
\value{
one \code{data.frame} for each instrument/form in a REDCap project. By
default the datasets are saved into the global environment.
}
\description{
This function takes the url and key for a REDCap
project and returns a table for each instrument/form in the project.
}
\examples{
\dontrun{
import_instruments(
  "https://redcap.miami.edu/api/",
  Sys.getenv("test_API_key")
)
}
}
