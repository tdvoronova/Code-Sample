
## Overview

This repository contains a simplified version of the R code developed for my Master’s thesis.
The code demonstrates the main analytical steps used to assess the impact of Russian immigration to Georgia on housing affordability.

It reproduces a minimal working example of the data preparation, econometric modeling, and visualization workflow.



## What the script does

* Compiles and merges two datasets:

  * A time-series dataset with nationwide indicators
  * A panel dataset with city-level rent and inflation data
    
* Estimates:

  * OLS models to analyze the relationship between rent inflation and migration shocks
  * Two-way fixed effects (TWFE) models for city-specific dynamics
    
* Visualizes rent price growth and major migration shock periods in Georgia



## Files

* `code-snippet.R` — main R script with data preparation, models, and visualization
* `df.csv` — dataset compiled for the analysis 
* `RUShing_to_Georgia_Thesis.pdf` - master's thesis providing the complete empirical analysis and discussion.

## About the Thesis
The thesis analyzes how sudden migration inflows following Russia’s 2022 invasion of Ukraine affected rent growth and housing affordability in Georgia.  
Using OLS and two-way fixed effects models, it identifies significant rent surges, particularly in Tbilisi, during major migration waves, with limited wage adjustment and a decline in affordability.

For detailed methods and results, see **Sections 3–5** of the attached thesis.


## More
If you wish to explore the full version of the code and data preparation pipeline, please visit:
 [Master’s Thesis Repository](https://github.com/tdvoronova/masters-thesis)
