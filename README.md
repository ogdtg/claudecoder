# claudecoder — Claude Code R

`claudecoder` is a lightweight helper that scaffolds a new R project ready for use
with **Claude Code Web**. It creates a clean project skeleton, drops in the
right `CLAUDE.md` instruction files, initialises git and pushes the
repository to GitHub — and it ships helpers to anonymise your real data
into a safe, shareable form.

## Installation

```r
# install.packages("remotes")
remotes::install_github("ogdtg/claudecoder")
```

## Create a project

```r
library(claudecoder)

create_ccr_repo(
  name                = "my_analysis",
  directory           = "~/projects",
  template            = "normal",        # or "dashboard", "package"
  github_organisation = NULL,             # NULL = your own account
  private             = TRUE
)
```

This will:

1. Create an R project at `~/projects/my_analysis`.
2. Add the sub-directories `R/`, `anonym_data/` and `real_data/`.
3. Copy the template `CLAUDE.md` files to the project root, `R/` and
   `anonym_data/`.
4. Write an R-style `.gitignore` that ignores the `.Rproj` file and the
   `real_data/` directory.
5. Run `usethis::use_git()` and commit everything.
6. Run `usethis::use_github()` and push the repository.

## Templates

Each template is a directory under `inst/templates/` holding three
`CLAUDE.md` files (project root, `R/`, `anonym_data/`). Available
templates:

- `normal` — standard R data analysis project
- `dashboard` — Shiny dashboard project (`template = "dashboards"` also works)
- `package` — R package development

```r
list_templates()
```

Templates are fully editable and expandable: edit the files under
`inst/templates/<name>/`, or add a new sub-directory with its own three
`CLAUDE.md` files, and it becomes available to `create_ccr_repo()`.

Every `CLAUDE.md` tells Claude Code that the data to work with lives in
`anonym_data/` and the functions and code live in `R/`. The
`anonym_data/CLAUDE.md` additionally states that only anonymised data is
present and that the **real data cannot be shared with Claude Code for
data-security reasons**.

## Anonymising data

Real data lives in `real_data/` (git-ignored) and must never be shared.
Use the helpers to produce anonymised samples (max 20 rows) in
`anonym_data/`:

```r
# Permute the values within each column (breaks row linkage)
anonymize_dir("real_data", "anonym_data", method = "shuffle")

# Replace each column with type-matched random values
anonymize_dir("real_data", "anonym_data", method = "replace")
```

The building blocks are also exported:

- `shuffle_dataset(data)` — independently shuffles each column.
- `replace_columns(data)` — replaces each column with random values of the
  same data type (numeric → numeric, character → character, …).

Both are capped to 20 rows by `anonymize_dir()` before writing.
