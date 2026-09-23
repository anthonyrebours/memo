memo <- function(filtre = NULL, file = file.path(Sys.getenv("MEMO_PATH"))) {
  l <- readLines(file, encoding = "UTF-8", warn = FALSE)
  l <- l[nzchar(trimws(l))]
  section <- cumsum(startsWith(l, "# "))

  for (s in unique(section)) {
    bloc  <- l[section == s]
    titre <- sub("^# ", "", bloc[1])
    corps <- bloc[-1]

    if (!is.null(filtre) && !grepl(filtre, titre, ignore.case = TRUE)) {
      corps <- grep(filtre, corps, value = TRUE, ignore.case = TRUE, fixed = FALSE)
    }
    if (length(corps) == 0) next

    cat("\n\033[1;36m", toupper(titre), "\033[0m\n", sep = "")
    for (x in corps) {
      p <- strsplit(x, " => ", fixed = TRUE)[[1]]
      cat("  \033[33m", p[1], "\033[0m",
          if (length(p) > 1) paste0("\n      ", p[2]),
          "\n", sep = "")
    }
  }
  invisible(NULL)
}