# Replication of Besley & Burgess (2004)

# Besley & Burgess (2004) — Replication in R (DiD Diagnostics, Heterogeneity, Robustness)

This repository replicates and extends the core empirical patterns in **Besley & Burgess (2004)** using
a transparent, reproducible workflow in **R**. The focus is on **manufacturing employment** and
**manufacturing output**, using Difference-in-Differences (DiD), event-study diagnostics, heterogeneity,
and robustness checks.

## Research question
How does stricter labour regulation affect:
1) manufacturing employment, and  
2) manufacturing output?

## Data (local)
Raw data files are **not uploaded** to GitHub. Place them locally in:

- `data/raw/industry/Industry.dta`
- `data/raw/socioeconomics/Socioeconomic.dta`

The analysis produces a cleaned state–year panel saved to:

- `data/processed/panel_state_year.csv`

## Key variables
**Treatment**
- `strict`: cumulative labour regulation index
- `nstrict`: normalized regulation index (robustness)

**Outcomes**
- `employm`: manufacturing employment (main)
- `workers`: alternative employment measure (robustness)
- `nsdpmanr`: registered manufacturing output (main)
- `nsdpman`: alternative output measure (robustness)

## Method (high level)
Baseline specification with state and year fixed effects:

\[
\ln(Y_{st}) = \beta \cdot Regulation_{st} + \alpha_s + \gamma_t + \varepsilon_{st}
\]

Parallel trends are assessed via event studies around the first observed regulation change
(with event time binned to avoid sparse leads/lags).

## What this repo contains
- Clean panel construction (state–year)
- DiD diagnostics (event studies)
- Heterogeneity (baseline manufacturing intensity; baseline regulation)
- Robustness (alternative treatment and outcome measures)
- Reproducible environment using `renv`

## How to run
1. Open the project in RStudio (`.Rproj`)
2. Setup packages / environment:
   - `code/00_setup.R`
3. Build the cleaned panel:
   - `code/03c_construct_clean_panel.R`
4. Diagnostics (TWFE + event studies):
   - `code/04_did_diagnostics.R`
5. Heterogeneity:
   - `code/05_heterogeneity.R`
6. Robustness:
   - `code/06_robustness.R`

## Repository structure
- `code/` scripts
- `data/raw/` (ignored) raw input files
- `data/processed/` processed datasets used for estimation
- `output/figures/` figures (optional)
- `output/tables/` tables (optional)
- `notes/` write-up and documentation (added next)

## Notes on inference
Standard errors are clustered at the state level. With a small number of clusters, clustered variance
estimates can be numerically sensitive in high-dimensional event-study specifications. `fixest` applies
a correction when the clustered VCOV is not positive semi-definite; coefficient estimates are unchanged
and the correction affects only reported standard errors/confidence intervals.

