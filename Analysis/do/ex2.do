********************************************
* Yifan Lyu, 29th Sep 2021
* Stockholm School of Economics
* 
* ex2: use old data to predict new
********************************************

clear all
set more off
global path "/Users/frankdemacbookpro/Dropbox/SSE_yr2/Applied_Empirical/Yifan_Lyu/Task6"
use "${path}/Build/Output/92_02_cleaned.dta", replace

******************* PREPARATION ************************************************
* keep 80% of observation
set seed 1234


* I choose Lasso to fit the old dataset parameter
lasso linear ln_y *norm, folds(10) rseed(1234)
estimates store lasso


* then load the new dataset
use "${path}/Build/Output/02_11_cleaned.dta", replace

lassogof lasso


* No, the fit is worse, as we can see in the orginal data, the MSE from lasso is .076507
* However, the new data predicted by lassos has MSE of  .1212723




