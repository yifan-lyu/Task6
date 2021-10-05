********************************************
* Yifan Lyu, 29th Sep 2021
* Stockholm School of Economics
* 
* ex1: subset selection, lasso, ridge and PCA.
* for each method, 10 fold cross validation is used
********************************************

clear all
set more off
global path "/Users/frankdemacbookpro/Dropbox/SSE_yr2/Applied_Empirical/Yifan_Lyu/Task6"
use "${path}/Build/Output/92_02_cleaned.dta", replace
cap log close
log using "${path}/Log/Task6_ex1.log", replace

******************* PREPARATION ************************************************
* keep 80% of observation
set seed 1234
*count
*gen insample = 1 == (v1 < `r(N)'*0.8) // another way to do this
splitsample, generate(insample) split(0.8 0.2) 
label de svalues 1 "Training" 2 "Testing"
label val insample svalues
order insample, first


*mean squared error program
cap prog drop findmse

prog findmse
* This program calcualtes out of sample MSE, to determine the best model among all models
args yhat ln_y df
gen sqerr = (`yhat'-`ln_y')^2
egen mse = total(sqerr)
replace mse = mse/`df'
mean mse
drop sqerr mse
end

cap prog drop MSEfinder
matrix drop _all

prog MSEfinder
set seed 1234
* This program calculates within sample MSE, to determine the best model for PCA regression
args ln_y X
qui crossfold: xi: regress `ln_y' `X', k(10)
matrix a = r(est)
* matrix list a
svmat double a, name(modela)
gen MSE = modela1^2
mean MSE
drop modela1 MSE
end

********************************************************************************
* subset selection
vselect ln_y *_norm if insample == 1, forward r2adj // stata does not have cross validation within sample
predict yhat_select if insample == 2
local df = `e(df_r)'
findmse yhat_select ln_y `df'


* principal component regression
qui pca ln_y *norm
local X "pc1 pc2 pc3 pc4 pc5 pc6"
qui predict "`X'", score
MSEfinder ln_y "`X'" // use this method we find that adding up to pc6 gives min MSE in sample

qui reg ln_y if insample == 1
local df = `e(df_r)'
predict yhat_pcr if insample == 2 // then we find out of sample MSE
findmse yhat_pcr ln_y `df'


* lasso
qui lasso linear ln_y *norm if insample == 1, folds(10) rseed(1234)
estimates store lasso

* ridge
qui elasticnet linear ln_y *norm if insample == 1, folds(10) alphas(0) rseed(1234)
estimates store ridge

* elastic net
qui elasticnet linear ln_y *norm if insample == 1, folds(10) rseed(1234)
estimates store elastic

* print result for lasso and ridge
lassogof elastic ridge lasso, over(insample)

* mean ols
qui reg ln_y if insample == 1
local df = `e(df_r)'
predict yhat_meanols if insample == 2
findmse yhat_meanols ln_y `df'

* kitchen sink ols
qui reg ln_y *norm if insample == 1
local df = `e(df_r)'
predict yhat_kitchen if insample == 2
findmse yhat_kitchen ln_y `df'

log close

