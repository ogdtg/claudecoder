test_that("shuffle_dataset preserves structure and per-column values", {
  df <- data.frame(a = 1:5, b = letters[1:5], stringsAsFactors = FALSE)
  out <- shuffle_dataset(df)
  expect_equal(dim(out), dim(df))
  expect_equal(names(out), names(df))
  expect_setequal(out$a, df$a)
  expect_setequal(out$b, df$b)
})

test_that("replace_columns keeps types and dimensions", {
  df <- data.frame(
    num = c(1.5, 2.5, 3.5),
    int = 1:3,
    chr = c("x", "y", "z"),
    lgl = c(TRUE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  out <- replace_columns(df)
  expect_equal(dim(out), dim(df))
  expect_type(out$num, "double")
  expect_type(out$int, "integer")
  expect_type(out$chr, "character")
  expect_type(out$lgl, "logical")
})

test_that("cap_rows never returns more than max_rows", {
  df <- data.frame(a = 1:100)
  expect_lte(nrow(cap_rows(df, 20L)), 20L)
  expect_equal(nrow(cap_rows(df[1:5, , drop = FALSE], 20L)), 5L)
})

test_that("anonymize_dir writes at most 20 rows per file", {
  real <- tempfile("real")
  anon <- tempfile("anon")
  dir.create(real)
  write.csv(data.frame(a = 1:100, b = letters[rep(1:25, 4)]),
            file.path(real, "d.csv"), row.names = FALSE)
  anonymize_dir(real, anon, method = "shuffle")
  res <- read.csv(file.path(anon, "d.csv"))
  expect_lte(nrow(res), 20L)
})
