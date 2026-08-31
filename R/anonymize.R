#' Cap a data frame to a maximum number of rows
#'
#' Randomly samples at most `max_rows` rows (default 20) from `data`.
#'
#' @param data A data frame.
#' @param max_rows Maximum number of rows to keep.
#' @return A data frame with at most `max_rows` rows.
#' @keywords internal
cap_rows <- function(data, max_rows = 20L) {
  n <- nrow(data)
  if (n <= max_rows) {
    return(data)
  }
  data[sample(n, max_rows), , drop = FALSE]
}

#' Generate a vector of random character strings
#'
#' @param n Number of strings to generate.
#' @param width Character width of each string.
#' @return A character vector of length `n`.
#' @keywords internal
random_string <- function(n, width = 8L) {
  pool <- c(letters, LETTERS, 0:9)
  vapply(
    seq_len(n),
    function(i) paste0(sample(pool, width, replace = TRUE), collapse = ""),
    character(1)
  )
}

#' Replace a single column with random values of the same data type
#'
#' Numeric columns get random numbers within their observed range,
#' character columns get random strings, factors are resampled from their
#' levels, logicals get random TRUE/FALSE and dates get random dates in
#' the observed range. Missing values are preserved in place.
#'
#' @param col A vector (one column of a data frame).
#' @return A vector of the same length and type with randomised content.
#' @keywords internal
replace_one_column <- function(col) {
  n <- length(col)
  na <- is.na(col)
  if (inherits(col, "Date")) {
    rng <- range(as.numeric(col), na.rm = TRUE)
    out <- as.Date(round(stats::runif(n, rng[1], rng[2])), origin = "1970-01-01")
  } else if (is.factor(col)) {
    out <- factor(sample(levels(col), n, replace = TRUE), levels = levels(col))
  } else if (is.logical(col)) {
    out <- sample(c(TRUE, FALSE), n, replace = TRUE)
  } else if (is.integer(col)) {
    rng <- range(col, na.rm = TRUE)
    out <- as.integer(round(stats::runif(n, rng[1], rng[2])))
  } else if (is.numeric(col)) {
    rng <- range(col, na.rm = TRUE)
    out <- stats::runif(n, rng[1], rng[2])
  } else {
    out <- random_string(n)
  }
  out[na] <- NA
  out
}

#' Shuffle a dataset column by column
#'
#' Independently permutes the values within each column, breaking the link
#' between columns while preserving every column's distribution.
#'
#' @param data A data frame.
#' @return A data frame with the same columns, values shuffled per column.
#' @export
shuffle_dataset <- function(data) {
  stopifnot(is.data.frame(data))
  data[] <- lapply(data, function(col) col[sample(length(col))])
  data
}

#' Replace every column with type-matched random values
#'
#' Each column is replaced by random values that match its data type (a
#' numeric column gets numeric values, a character column gets character
#' values, and so on) via [replace_one_column()].
#'
#' @param data A data frame.
#' @return A data frame with the same structure and randomised content.
#' @export
replace_columns <- function(data) {
  stopifnot(is.data.frame(data))
  data[] <- lapply(data, replace_one_column)
  data
}

#' Anonymise real data files into the shareable directory
#'
#' Reads every CSV file from `real_dir`, anonymises it with the chosen
#' `method`, caps it at `max_rows` rows (20 by default) and writes the
#' result to `anonym_dir`. Intended to turn `real_data/` files into safe
#' samples in `anonym_data/`.
#'
#' @param real_dir Directory holding the real CSV files.
#' @param anonym_dir Directory to write the anonymised CSV files to.
#' @param method Either "shuffle" (permute values per column) or
#'   "replace" (type-matched random values).
#' @param max_rows Maximum number of rows to keep per file.
#' @return Invisibly, the paths of the written files.
#' @export
anonymize_dir <- function(real_dir = "real_data",
                          anonym_dir = "anonym_data",
                          method = c("shuffle", "replace"),
                          max_rows = 20L) {
  method <- match.arg(method)
  transform <- if (method == "shuffle") shuffle_dataset else replace_columns
  if (!dir.exists(anonym_dir)) {
    dir.create(anonym_dir, recursive = TRUE)
  }
  files <- list.files(real_dir, pattern = "\\.csv$", full.names = TRUE,
                      ignore.case = TRUE)
  written <- character(0)
  for (f in files) {
    data <- utils::read.csv(f, stringsAsFactors = FALSE)
    data <- cap_rows(transform(data), max_rows = max_rows)
    out <- file.path(anonym_dir, basename(f))
    utils::write.csv(data, out, row.names = FALSE)
    written <- c(written, out)
  }
  invisible(written)
}
