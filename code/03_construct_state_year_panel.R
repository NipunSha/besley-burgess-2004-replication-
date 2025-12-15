
library(tidyverse)
library(haven)
library(here)

# Load data
industry <- read_dta(here("data/raw/industry/Industry.dta"))
socio    <- read_dta(here("data/raw/socioeconomics/Socioeconomic.dta"))

# Keep only required variables
industry_clean <- industry %>%
  select(state, statenm, year,
         strict, nstrict,
         employm, workers, pertot)

socio_clean <- socio %>%
  select(state, year,
         nsdpmanr, nsdpman)

# Merge to state-year panel
panel <- industry_clean %>%
  left_join(socio_clean, by = c("state", "year"))

# Basic checks
summary(panel)
glimpse(panel)

# Save processed panel
write_csv(panel, here("data/processed/panel_state_year.csv"))

