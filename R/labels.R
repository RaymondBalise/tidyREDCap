# These are S3 methods for the labelled objects coming from {labelVector}
# The {vctrs} package needs these for working in {dplyr} 

#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_ptype2

#### Checking types of objects ####

##### both labelled #####
#' @export
vec_ptype2.labelled.labelled <- function(x, y, ...) {
  x
}

##### char #####
#' @export
vec_ptype2.labelled.character <- function(x, y, ...) {
  x
}

#' @export
vec_ptype2.character.labelled <- function(x, y, ...) {
  y
}

##### integer ##### 
#' @export
vec_ptype2.labelled.integer <- function(x, y, ...) {
  x
}

#' @export
vec_ptype2.integer.labelled <- function(x, y, ...) {
  y
}

##### double ##### 
#' @export
vec_ptype2.labelled.double <- function(x, y, ...) {
  x
}

#' @export
vec_ptype2.double.labelled <- function(x, y, ...) {
  y
}


##### logical #####
#' @export
vec_ptype2.labelled.logical <- function(x, y, ...) {
  x
}

#' @export
vec_ptype2.logical.labelled <- function(x, y, ...) {
  y
}

#### Casting to fix attributes ####
# These functions all return the object `x` itself if it was already labelled 
#   or `x` with the label from the `to` object.

##### both labelled #####
#' @export
vec_cast.labelled.labelled <- function(x, to, ...) {
  # if the labels match return identity(x) otherwise explode
  if (identical(attributes(x)[["label"]], attributes(to)[["label"]])) {
    return(x)
  } else {
    cli::cli_abort(
      c(x = "You are trying to combine variables with different labels",
        "You can use tidyREDCap::drop_label() to erase one.")
    )
  }
}

##### char #####
#' @export
vec_cast.character.labelled <- function(x, to, ...) {
  var_label(x) <- var_label(to)
  x
}

#' @export
vec_cast.labelled.character <- function(x, to, ...) {
  x
} 

##### integer #####
#' @export
vec_cast.integer.labelled <- function(x, to, ...) {
  var_label(x) <- var_label(to)
  x
}

#' @export
vec_cast.labelled.integer <- function(x, to, ...) {
  x
} 

##### double #####
#' @export
vec_cast.double.labelled <- function(x, to, ...) {
  var_label(x) <- var_label(to)
  x
}

#' @export
vec_cast.labelled.double <- function(x, to, ...) {
  x
} 

##### logical #####
#' @export
vec_cast.logical.labelled <- function(x, to, ...) {
  var_label(x) <- var_label(to)
  x
}

#' @export
vec_cast.labelled.logical <- function(x, to, ...) {
  x
} 