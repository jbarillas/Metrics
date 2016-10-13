***Figure 3.1.3 Replication using 1980 IPUMS
**Use this .do file only after you've ran the Stata command file on the raw data
*Selection: 40-49 year old white males
numlabel, add
keep if sex==1
keep if age>=40 & age<=49
keep if race==1

*Generate schooling variable
gen school = higrade
drop if school == 1 | school == 2
drop if school==.

save mhe_cleaned, replace

*Generate log of wages
gen earnings=ln(incwage)

**Panel A
*Run OLS regression w/ individual data, robust std errors
reg earnings school, robust
est store ind

*Generate conditional means
gen count=1 if e(sample)
collapse (sum) count (mean) earnings, by(school)

**Panel B
*Run OLS regression w/ grouped data, robust std errors
reg earnings school [aweight=count], robust
est store avg

*Create comparison table w/ std errors
est table ind avg, se stats(r2 N)

clear
