# 01_build_regulation_index.R
# Project: Replication of Besley & Burgess (2004)
# Purpose: Construct state-year labour regulation index

# Packages
library(tidyverse)
library(here)

# -----------------------------
# 1. Read amendment-level data
# -----------------------------

# Expected structure:
# state | year | amendment_direction
# amendment_direction ∈ {-1, 0, 1}

# Placeholder for now
# amendments <- read_csv(here("data/raw/labour_amendments.csv"))

# -----------------------------
# 2. Collapse to state-year
# -----------------------------

# amendments_state_year <- amendments %>%
#   group_by(state, year) %>%
#   summarise(direction = sum(amendment_direction), .groups = "drop")

# -----------------------------
# 3. Construct cumulative index
# -----------------------------

# regulation_index <- amendments_state_year %>%
#   arrange(state, year) %>%
#   group_by(state) %>%
#   mutate(reg_index = cumsum(direction)) %>%
#   ungroup()

# -----------------------------
# 4. Save processed output
# -----------------------------

# write_csv(regulation_index,
#           here("data/processed/regulation_index.csv"))

amendments <- readr::read_csv(here::here("data/raw/labour_amendments.csv"))

