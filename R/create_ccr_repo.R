#' Create the project sub-directories used by a ccr project
#'
#' Ensures `R/`, `anonym_data/` and `real_data/` exist, each with a
#' `.gitkeep` so empty directories are tracked (except `real_data/`, which
#' stays git-ignored).
#'
#' @param project_dir Project root directory.
#' @return Invisibly, `project_dir`.
#' @keywords internal
create_project_dirs <- function(project_dir) {
  subdirs <- c("R", "anonym_data", "real_data")
  for (d in subdirs) {
    path <- file.path(project_dir, d)
    if (!dir.exists(path)) {
      dir.create(path, recursive = TRUE)
    }
  }
  file.create(file.path(project_dir, "anonym_data", ".gitkeep"))
  invisible(project_dir)
}

#' Write the standard R .gitignore for a ccr project
#'
#' Overwrites the project's `.gitignore` with the ccr defaults, which
#' ignore the `.Rproj` file and the `real_data/` directory.
#'
#' @param project_dir Project root directory.
#' @return Invisibly, the path to the written `.gitignore`.
#' @keywords internal
write_gitignore <- function(project_dir) {
  path <- file.path(project_dir, ".gitignore")
  writeLines(ccr_gitignore(), path)
  invisible(path)
}

#' Stage and commit everything in a git repository
#'
#' @param project_dir Project root directory (a git repository).
#' @param message Commit message.
#' @return Invisibly, `TRUE`.
#' @keywords internal
git_commit_all <- function(project_dir, message) {
  system2("git", c("-C", shQuote(project_dir), "add", "-A"))
  system2("git", c("-C", shQuote(project_dir), "commit", "-m",
                   shQuote(message)))
  invisible(TRUE)
}

#' Create a new R project ready for Claude Code Web
#'
#' Scaffolds an R project with `R/`, `anonym_data/` and `real_data/`
#' directories, drops in the CLAUDE.md files for the chosen `template`,
#' writes an R-style `.gitignore` (ignoring the `.Rproj` file and
#' `real_data/`), initialises git, commits everything and creates and
#' pushes a GitHub repository.
#'
#' @param name Name of the project (used as the directory and repo name).
#' @param directory Parent directory in which to create the project.
#' @param template CLAUDE.md template to use. See [list_templates()] for
#'   the available templates (e.g. "normal", "dashboard", "package").
#' @param github_organisation Optional GitHub organisation to create the
#'   repository under; defaults to the authenticated user's account.
#' @param private Whether the GitHub repository should be private.
#' @return Invisibly, the path to the created project.
#' @export
create_ccr_repo <- function(name, directory, template = "normal",
                            github_organisation = NULL, private = TRUE) {
  project_dir <- file.path(directory, name)
  usethis::create_project(project_dir, open = FALSE)
  create_project_dirs(project_dir)
  copy_template(template, project_dir)
  write_gitignore(project_dir)
  usethis::with_project(project_dir, {
    usethis::use_git()
    git_commit_all(project_dir, "Initial ccr project setup")
    usethis::use_github(organisation = github_organisation, private = private)
  })
  invisible(project_dir)
}
