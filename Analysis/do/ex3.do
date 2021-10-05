********************************************
* Yifan Lyu, 29th Sep 2021
* Stockholm School of Economics
* 
* ex3: use new data to perform subset selection
********************************************

clear all
set more off
global path "/Users/frankdemacbookpro/Dropbox/SSE_yr2/Applied_Empirical/Yifan_Lyu/Task6"
use "${path}/Build/Output/02_11_cleaned.dta", replace
cap log close
log using "${path}/Log/Task6_ex3.log", replace


* subset selection
vselect ln_y *_norm , forward r2adj // stata does not have cross validation within sample

/*
Below is the variables selected in the old dataset: (norm means its normalised variables)
age_dep_young_norm
inf_mort_norm
effectiveness_norm
growth_norm
urban_norm
ext_bal_norm
gvmnt_c_norm
fem_emp_norm
regulation_norm
inflation_norm
parliamentary_norm
hc_norm
voice_norm
trade_norm
********************************************************************************
Below is the variables selected in the new dataset:
effectiveness_norm
inf_mort_norm
ext_bal_norm
hc_norm
urban_norm
fem_emp_norm
age_dep_young_norm
growth_norm
competitiveness_leg_norm
yrsoffc_norm
parliamentary_norm
corruption_norm
military_norm
inflation_norm
gcf_norm
voice_norm
law_norm
competitiveness_exec_n~m
regulation_norm

We can see that variables selected are not the same
*/

log close
