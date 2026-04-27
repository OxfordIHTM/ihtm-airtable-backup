## Load .env if present
if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}


## Set repos options ----
options(
  repos = c(
    CRAN = "https://cloud.r-project.org",
    IHTM = "https://oxfordihtm.r-universe.dev"
  )
)

source("renv/activate.R")

