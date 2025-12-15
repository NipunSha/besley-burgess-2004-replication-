library(tidyverse)
library(fixest)
library(here)

# -----------------------------
# 1) Load panel
# -----------------------------
panel <- read_csv(here("data/processed/panel_state_year.csv"))

# -----------------------------
# 2) Define CLEAN analysis sample
# -----------------------------
panel_use <- panel %>%
  filter(year >= 1960, year <= 1995) %>%        # common window
  filter(!is.na(employm), employm > 0) %>%      # log-defined employment
  filter(!is.na(nsdpmanr), nsdpmanr > 0) %>%    # log-defined output
  mutate(
    ln_employm  = log(employm),
    ln_nsdpmanr = log(nsdpmanr)
  )

# -----------------------------
# 3) Baseline TWFE (clean)
# -----------------------------
did_emp <- feols(
  ln_employm ~ strict | state + year,
  data = panel_use,
  cluster = "state"
)

did_out <- feols(
  ln_nsdpmanr ~ strict | state + year,
  data = panel_use,
  cluster = "state"
)

summary(did_emp)
summary(did_out)

# -----------------------------
# 4) Construct clean event time
# -----------------------------
panel_use <- panel_use %>%
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
  ) %>%
  filter(!is.na(rel_year))

# -----------------------------
# 5) Cap event window (±10)
# -----------------------------
panel_use <- panel_use %>%
  mutate(
    rel_bin = case_when(
      rel_year < -10 ~ -10,
      rel_year >  10 ~  10,
      TRUE           ~ rel_year
    )
  )

# -----------------------------
# 6) Event study: Employment
# -----------------------------
es_emp <- feols(
  ln_employm ~ i(rel_bin, ref = -1) | state + year,
  data = panel_use,
  cluster = "state"
)

png(
  filename = here("output/figures/event_study_employment.png"),
  width = 800,
  height = 500
)

iplot(
  es_emp,
  xlab = "Years relative to first regulation change (binned at ±10)",
  main = "Event Study: Manufacturing Employment"
)

dev.off()



# -----------------------------
# 7) Event study: Output
# -----------------------------
es_out <- feols(
  ln_nsdpmanr ~ i(rel_bin, ref = -1) | state + year,
  data = panel_use,
  cluster = "state"
)


png(
  filename = here("output/figures/event_study_output.png"),
  width = 800,
  height = 500
)

iplot(
  es_out,
  xlab = "Years relative to first regulation change (binned at ±10)",
  main = "Event Study: Manufacturing Output"
)

dev.off()


