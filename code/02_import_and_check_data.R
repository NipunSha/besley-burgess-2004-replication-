library(tidyverse)
library(haven)
library(here)

industry <- read_dta(here("data/raw/industry/Industry.dta"))
socio    <- read_dta(here("data/raw/socioeconomics/Socioeconomic.dta"))

names(industry)
names(socio)
