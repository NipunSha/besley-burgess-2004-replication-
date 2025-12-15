library(tidyverse)
library(haven)
library(here)

industry <- read_dta(here("data/raw/industry/Industry.dta"))
socio    <- read_dta(here("data/raw/socioeconomics/Socioeconomic.dta"))

industry_clean <- industry %>%
  select(state, statenm, year, strict, nstrict, employm, workers, pertot)

socio_clean <- socio %>%
  select(state, year, nsdpmanr, nsdpman)

# 1) Check duplicates in each dataset
dup_ind <- industry_clean %>%
  count(state, year) %>%
  filter(n > 1) %>%
  arrange(desc(n))

dup_soc <- socio_clean %>%
  count(state, year) %>%
  filter(n > 1) %>%
  arrange(desc(n))

print(dup_ind)
print(dup_soc)
