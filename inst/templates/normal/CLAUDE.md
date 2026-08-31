# Project instructions

This is a standard R data analysis project.

## Where things live
- `anonym_data/` holds the **only** data you may read. It contains
  anonymised samples (max 20 rows) that are safe to share.
- `R/` holds all functions and code. Reuse existing helpers there.
- `real_data/` is **not available** to you and is git-ignored.

## Coding rules
- Do not define functions inside functions.
- Define helper functions and reuse them wherever needed.
- Keep docstrings brief and concise.
- Write code in `R/`, sourcing helpers rather than duplicating logic.

## Data
Real data cannot be shared for data-security reasons. Develop and test
against the anonymised samples in `anonym_data/` only.
