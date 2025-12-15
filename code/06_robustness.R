library(tidyverse)
library(fixest)
library(here)

# Load panel
panel <- read_csv(here("data/processed/panel_state_year.csv"))

# Common clean sample
panel_use <- panel %>%
  filter(year >= 1960, year <= 1995) %>%
  filter(!is.na(employm), employm > 0) %>%
  filter(!is.na(workers), workers > 0) %>%
  filter(!is.na(nsdpmanr), nsdpmanr > 0) %>%
  filter(!is.na(nsdpman), nsdpman > 0) %>%
  mutate(
    ln_employm  = log(employm),
    ln_workers  = log(workers),
    ln_nsdpmanr = log(nsdpmanr),
    ln_nsdpman  = log(nsdpman)
  )

# -----------------------------
# 1) Baseline (for comparison)
# -----------------------------
base_emp <- feols(
  ln_employm ~ strict | state + year,
  data = panel_use,
  cluster = "state"
)

# -----------------------------
# 2) Robustness: nstrict
# -----------------------------
rob_emp_nstrict <- feols(
  ln_employm ~ nstrict | state + year,
  data = panel_use,
  cluster = "state"
)

# -----------------------------
# 3) Robustness: workers
# -----------------------------
rob_workers <- feols(
  ln_workers ~ strict | state + year,
  data = panel_use,
  cluster = "state"
)

# -----------------------------
# 4) Robustness: output measure
# -----------------------------
rob_output <- feols(
  ln_nsdpman ~ strict | state + year,
  data = panel_use,
  cluster = "state"
)

# -----------------------------
# Summaries
# -----------------------------
summary(base_emp)
summary(rob_emp_nstrict)
summary(rob_workers)
summary(rob_output)
