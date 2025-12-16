# Replication of Besley & Burgess (2004)
## Labour Regulation and Manufacturing Outcomes in Indian States

This repository replicates and extends the core empirical analysis in **Besley & Burgess (2004)**, which studies the effects of labour regulation on manufacturing activity across Indian states. The replication is implemented in **R** using a transparent and fully reproducible workflow, with particular attention to modern Difference-in-Differences (DiD) diagnostics.

The focus is on **manufacturing employment** and **manufacturing output**, using state–year panel data and two-way fixed effects specifications. In addition to reproducing baseline results, the analysis examines dynamic treatment effects, heterogeneity across states, and robustness to alternative measures.

---

## Research question

How does stricter labour regulation affect:

- manufacturing employment, and  
- manufacturing output  

across Indian states over time?

---

## Data

Raw data files are **not** included in this repository and must be placed locally by the user:

data/raw/industry/Industry.dta

data/raw/socioeconomics/Socioeconomic.dta


From these inputs, the analysis constructs a cleaned **state–year panel**, which is saved as:

data/processed/panel_state_year.csv


This processed file is the basis for all subsequent estimation.

---

## Key variables

### Labour regulation
- `strict`: cumulative labour regulation index  
- `nstrict`: normalized regulation index (used in robustness checks)

### Outcomes
- `employm`: manufacturing employment (main outcome)
- `workers`: alternative employment measure (robustness)
- `nsdpmanr`: registered manufacturing output (main outcome)
- `nsdpman`: alternative output measure (robustness)

---

## Empirical approach

The baseline specification follows a standard two-way fixed effects Difference-in-Differences framework with state and year fixed effects. Identification relies on within-state changes in labour regulation over time.

Parallel trends are assessed using **event-study specifications** around the first observed regulatory change. Event time is binned to avoid sparsely supported leads and lags in later periods.

The analysis then explores:
- heterogeneity by baseline manufacturing intensity,
- heterogeneity by baseline regulatory environment, and
- robustness to alternative treatment and outcome definitions.

---

## Repository contents

- Clean construction of a state–year panel  
- DiD estimation with event-study diagnostics  
- Heterogeneity analysis  
- Robustness checks  
- Reproducible R environment using `renv`

---

## How to run the analysis

1. Open the project in RStudio (`.Rproj`)
2. Set up the R environment:

code/00_setup.R

3. Construct the cleaned panel:

code/03c_construct_clean_panel.R

4. DiD estimation and event-study diagnostics:

code/04_did_diagnostics.R

5. Heterogeneity analysis:

code/05_heterogeneity.R

6. Robustness checks:

code/06_robustness.R


---

## Notes on inference

Standard errors are clustered at the state level. Given the relatively small number of clusters and the inclusion of many lead–lag indicators in event-study specifications, clustered variance estimates can occasionally be numerically unstable.

When the clustered variance–covariance matrix is not positive semi-definite, `fixest` applies a correction. This does **not** affect coefficient estimates and only alters the reported standard errors and confidence intervals.

