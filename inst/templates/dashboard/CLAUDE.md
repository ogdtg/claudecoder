# Project instructions

This is a **Shiny dashboard** project.

## Where things live
- `anonym_data/` holds the **only** data you may read. It contains
  anonymised samples (max 20 rows) that are safe to share.
- `R/` holds all functions, modules and UI/server code. Reuse helpers.
- `real_data/` is **not available** to you and is git-ignored.

## Dashboarding rules
- Structure the app with Shiny modules; keep UI and server logic tidy.
- Do not define functions inside functions; extract helpers into `R/`.
- Define helper functions and reuse them wherever needed.
- Keep docstrings brief and concise.

## Data
Real data cannot be shared for data-security reasons. Build and preview
the dashboard against the anonymised samples in `anonym_data/` only.
