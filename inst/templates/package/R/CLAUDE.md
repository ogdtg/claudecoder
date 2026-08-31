# R/ directory (package development)

All exported and internal functions live here.

- Document every function with roxygen2; keep one concern per file.
- Do not define functions inside functions; extract helpers instead.
- Reuse existing helpers before writing new ones.
- Keep docstrings brief and concise.

Data to work with is in `anonym_data/` (anonymised, max 20 rows). The
real data in `real_data/` is not available for data-security reasons.
