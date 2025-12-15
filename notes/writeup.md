# Labour Regulation and Manufacturing Outcomes in India: Evidence from State-Level DiD

## 1. Motivation
Do labour market regulations constrain manufacturing performance in developing economies?
India provides a useful setting because labour regulation reforms vary across states and over time.
This project revisits the canonical Besley & Burgess (2004) setting using modern Difference-in-Differences
(DiD) diagnostics, heterogeneity analysis, and robustness checks in a fully reproducible workflow.

## 2. Data
The analysis combines two state–year panels:
(i) an industry dataset containing labour regulation indices and manufacturing outcomes, and
(ii) a socioeconomic dataset containing manufacturing output measures (including registered manufacturing NSDP).

The main treatment is **`strict`**, a cumulative labour regulation index capturing the direction and intensity
of amendments over time. Outcomes are **manufacturing employment** (`employm`) and **registered manufacturing
output** (`nsdpmanr`). The analysis window is restricted to **1960–1995** to ensure consistent outcome coverage.

## 3. Empirical Strategy
I estimate two-way fixed effects regressions with state and year fixed effects:

\[
\ln(Y_{st}) = \beta \cdot Regulation_{st} + \alpha_s + \gamma_t + \varepsilon_{st},
\]

where \(Y_{st}\) is manufacturing employment or manufacturing output in state \(s\) and year \(t\).
Standard errors are clustered at the state level.

Identification relies on the parallel trends assumption. I assess this using event-study specifications
centered on the first observed regulation change within a state. Event time is binned (e.g., ±10 years)
to reduce the influence of sparsely supported leads/lags.

## 4. Results and Diagnostics
Baseline DiD estimates indicate that stricter labour regulation is associated with a decline in manufacturing
employment. Event-study estimates show limited evidence of differential pre-trends prior to regulatory changes,
while post-treatment coefficients become increasingly negative over time. This pattern supports the plausibility
of the DiD design and is consistent with labour adjustment costs increasing under stricter regulation.

## 5. Heterogeneity
The negative employment effects are larger in:
1) states with higher baseline manufacturing intensity, and
2) states that were already highly regulated at baseline.

These patterns are consistent with the idea that labour market rigidities bind more strongly where formal
manufacturing is more prevalent and that additional regulation has larger marginal costs in already restrictive
environments.

## 6. Robustness
The core findings are robust to alternative measures:
- using the normalized regulation index (`nstrict`) in place of `strict`,
- using `workers` instead of `employm` as the employment measure,
- using `nsdpman` as an alternative output measure.

Across these specifications, the estimated relationship between labour regulation and manufacturing outcomes
remains negative and economically plausible.

## 7. Conclusion
Overall, the results reinforce the view that labour regulation can impede manufacturing labour outcomes,
particularly in states where manufacturing is more important or where regulation is already stringent.
The combination of modern event-study diagnostics, heterogeneity analysis, and robustness checks provides a
transparent and replication-ready applied econometrics workflow.
