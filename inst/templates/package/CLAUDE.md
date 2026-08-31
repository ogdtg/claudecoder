# Project instructions

This is an **R package development** project.

## Where things live
- `anonym_data/` holds the **only** data you may read. It contains
  anonymised samples (max 20 rows) that are safe to share.
- `R/` holds all exported and internal functions. Reuse helpers.
- `real_data/` is **not available** to you and is git-ignored.

## Package rules
- One function concern per file; document with roxygen2.
- Do not define functions inside functions; extract helpers instead.
- Define helper functions and reuse them wherever needed.
- Keep docstrings brief and concise.
- Keep `NAMESPACE`/`DESCRIPTION` consistent with the code.

## Data
Real data cannot be shared for data-security reasons. Use the
anonymised samples in `anonym_data/` for examples and tests only.
