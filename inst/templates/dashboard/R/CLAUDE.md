# R/ directory (Shiny dashboard)

All functions, Shiny modules and reusable code live here.

- Keep UI and server logic in modules; put shared logic in helpers.
- Do not define functions inside functions; extract helpers instead.
- Reuse existing helpers before writing new ones.
- Keep docstrings brief and concise.

Data to work with is in `anonym_data/` (anonymised, max 20 rows). The
real data in `real_data/` is not available for data-security reasons.
