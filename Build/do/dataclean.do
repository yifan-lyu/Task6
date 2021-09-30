********************************************
* Yifan Lyu, 29th Sep 2021
* Stockholm School of Economics
* 
* data cleaning - convert to dta and normalise
*
********************************************

clear all
set more off
prog drop _all
global path "/Users/frankdemacbookpro/Dropbox/SSE_yr2/Applied_Empirical/Yifan_Lyu/Task6"
set trace on // for debug use only
cap log close
log using "${path}/Log/Task6.log", replace

* clean
foreach name in "92_02" "02_11" {
	import delimited "${path}/Build/Raw/growthdata`name'.csv", clear
	qui ds v1 iso3, not  // exclude 
	* normalise variable
	foreach var of varlist `r(varlist)' {
	qui su `var'
	gen `var'_norm = (`var' - r(mean) )/(r(sd))  // mean zero, variance 1
	}
	drop ln_y_norm // we only use ln_y, y is not normalised
save "${path}/Build/Output/`name'_cleaned.dta", replace
}

* 


log close
