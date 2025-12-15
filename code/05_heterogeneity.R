library(tidyverse)
library(fixest)
library(here)

# -----------------------------
# 0) Load panel + create sample
# -----------------------------
panel <- read_csv(here("data/processed/panel_state_year.csv"))

# Main analysis window (clean overlap)
panel <- panel %>%
  filter(year >= 1960, year <= 1995) %>%
  mutate(
    ln_employm  = log(employm),
    ln_nsdpmanr = log(nsdpmanr)
  )

# -----------------------------
# 1) Create baseline groups (1960)
# -----------------------------

# Baseline manufacturing intensity (registered manufacturing NSDP in 1960)
base_man <- panel %>%
  filter(year == 1960) %>%
  select(state, nsdpmanr) %>%
  mutate(
    high_manuf = as.integer(nsdpmanr >= median(nsdpmanr, na.rm = TRUE))
  )

# Baseline regulation level (STRICT in 1960)
base_reg <- panel %>%
  filter(year == 1960) %>%
  select(state, strict) %>%
  mutate(
    high_reg = as.integer(strict >= median(strict, na.rm = TRUE))
  )

# Merge groups back into panel
panel <- panel %>%
  left_join(base_man %>% select(state, high_manuf), by = "state") %>%
  left_join(base_reg %>% select(state, high_reg), by = "state")

# Quick check (should be 0/1 with few NAs)
table(panel$high_manuf, useNA = "ifany")
table(panel$high_reg, useNA = "ifany")

# ------------------------------------------
# 2) Heterogeneity TWFE via interaction terms
# ------------------------------------------

# Employment outcome
het_emp_man <- feols(
  ln_employm ~ strict * high_manuf | state + year,
  data = panel,
  cluster = "state"
)

het_emp_reg <- feols(
  ln_employm ~ strict * high_reg | state + year,
  data = panel,
  cluster = "state"
)

# Output outcome
het_out_man <- feols(
  ln_nsdpmanr ~ strict * high_manuf | state + year,
  data = panel,
  cluster = "state"
)

het_out_reg <- feols(
  ln_nsdpmanr ~ strict * high_reg | state + year,
  data = panel,
  cluster = "state"
)

summary(het_emp_man)
summary(het_emp_reg)
summary(het_out_man)
summary(het_out_reg)

# Interpretation guide (print to console)
cat("\nINTERPRETATION (interaction TWFE)\n")
cat("- Coef on 'strict' = effect in LOW group (high_* = 0)\n")
cat("- Coef on 'strict:high_*' = additional effect in HIGH group\n")
cat("- Total effect in HIGH group = strict + (strict:high_*)\n\n")

# ------------------------------------------
# 3) Group-specific Event Study (diagnostics)
#    We cap the event window to avoid sparse tails.
# ------------------------------------------

# Define first year when strict changes (within each state)
panel <- panel %>%
  arrange(state, year) %>%
  group_by(state) %>%
  mutate(
    d_strict = strict - lag(strict),
    first_change = suppressWarnings(min(year[d_strict != 0], na.rm = TRUE))
  ) %>%
  ungroup() %>%
  mutate(
    first_change = ifelse(is.infinite(first_change), NA, first_change),
    rel_year = year - first_change
  )

# Cap event time to [-10, +10] for stability
panel <- panel %>%
  mutate(
    rel_bin = case_when(
      is.na(rel_year) ~ NA_real_,
      rel_year < -10  ~ -10,
      rel_year >  10  ~  10,
      TRUE            ~ rel_year
    )
  )

# Event study by baseline manufacturing group (employment)
es_emp_by_man <- feols(
  ln_employm ~ i(rel_bin, high_manuf, ref = -1) | state + year,
  data = panel,
  cluster = "state"
)

iplot(
  es_emp_by_man,
  xlab = "Years relative to first strict change (binned at ±10)",
  main = "Event Study: Employment, by baseline manufacturing intensity"
)

# Event study by baseline manufacturing group (output)
es_out_by_man <- feols(
  ln_nsdpmanr ~ i(rel_bin, high_manuf, ref = -1) | state + year,
  data = panel,
  cluster = "state"
)

iplot(
  es_out_by_man,
  xlab = "Years relative to first strict change (binned at ±10)",
  main = "Event Study: Output, by baseline manufacturing intensity"
)
