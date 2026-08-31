#' Path to the bundled template directory
#'
#' @return Absolute path to the `templates` directory shipped with ccr.
#' @keywords internal
ccr_template_root <- function() {
  system.file("templates", package = "ccr")
}

#' List the available CLAUDE.md templates
#'
#' Returns the names of the template directories shipped with ccr. Users
#' can add their own by creating a new sub-directory (with `CLAUDE.md`,
#' `R/CLAUDE.md` and `anonym_data/CLAUDE.md`) in the package's
#' `inst/templates` folder.
#'
#' @return A character vector of template names.
#' @export
list_templates <- function() {
  root <- ccr_template_root()
  if (identical(root, "")) {
    return(character(0))
  }
  list.dirs(root, full.names = FALSE, recursive = FALSE)
}

#' Resolve a template name to its directory
#'
#' Accepts loose spellings (e.g. "dashboards" -> "dashboard") and falls
#' back to "normal" when the requested template does not exist.
#'
#' @param template Requested template name.
#' @return Absolute path to the resolved template directory.
#' @keywords internal
resolve_template <- function(template = "normal") {
  root <- ccr_template_root()
  available <- list_templates()
  candidate <- template
  if (!candidate %in% available) {
    candidate <- sub("s$", "", candidate)
  }
  if (!candidate %in% available) {
    warning(sprintf("Template '%s' not found, using 'normal'.", template))
    candidate <- "normal"
  }
  file.path(root, candidate)
}

#' Copy the CLAUDE.md files of a template into a project
#'
#' Copies the top-level, `R/` and `anonym_data/` CLAUDE.md files from the
#' resolved template directory into the corresponding project locations.
#'
#' @param template Template name.
#' @param project_dir Target project directory.
#' @return Invisibly, the destination paths written.
#' @keywords internal
copy_template <- function(template, project_dir) {
  tdir <- resolve_template(template)
  rel <- c("CLAUDE.md", file.path("R", "CLAUDE.md"),
           file.path("anonym_data", "CLAUDE.md"))
  dest <- file.path(project_dir, rel)
  src <- file.path(tdir, rel)
  for (i in seq_along(src)) {
    if (file.exists(src[i])) {
      file.copy(src[i], dest[i], overwrite = TRUE)
    }
  }
  invisible(dest)
}

#' Standard R .gitignore content for a ccr project
#'
#' @return A character vector of .gitignore lines.
#' @keywords internal
ccr_gitignore <- function() {
  c(
    ".Rproj.user",
    ".Rhistory",
    ".RData",
    ".Ruserdata",
    ".httr-oauth",
    ".DS_Store",
    ".quarto",
    "*.Rproj",
    "real_data/"
  )
}
