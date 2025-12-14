# 00_setup.R
# Project: Replication of Besley & Burgess (2004)
# Purpose: Set up reproducible R environment and core packages

# Initialize renv (run only once)
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}
renv::init(bare = TRUE)

# Install core packages
packages <- c(
  "tidyverse",    # data manipulation
  "fixest",       # fixed effects regressions
  "modelsummary", # regression tables
  "here",         # file paths
  "arrow"         # fast data storage (optional)
)

renv::install(packages)

# Snapshot environment
renv::snapshot()
