library(tidyverse)
library(haven)
library(here)

# Load raw data
industry <- read_dta(here("data/raw/industry/Industry.dta"))
socio    <- read_dta(here("data/raw/socioeconomics/Socioeconomic.dta"))

# Drop non-state observations (state == NA)
industry_clean <- industry %>%
  filter(!is.na(state)) %>%
  select(state, statenm, year,
         strict, nstrict,
         employm, workers, pertot)

socio_clean <- socio %>%
  filter(!is.na(state)) %>%
  select(state, year,
         nsdpmanr, nsdpman)

# Sanity check: uniqueness
stopifnot(max(count(industry_clean, state, year)$n) == 1)
stopifnot(max(count(socio_clean, state, year)$n) == 1)

# Merge
panel <- industry_clean %>%
  left_join(socio_clean, by = c("state", "year"))

# Final check
stopifnot(max(count(panel, state, year)$n) == 1)

summary(panel)
glimpse(panel)

# Save panel
write_csv(panel, here("data/processed/panel_state_year.csv"))
