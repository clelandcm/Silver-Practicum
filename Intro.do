* Basics

di 1 + 2 + 3 // one plus two plus three

di 1 + 2 * 3 // one plus two times three

di (1 + 2) * 3 // first one plus two, then times three 

input x 
0
1
2
3
5
8
end

clear

set obs 11

egen myvar = seq(), from(1) to(11)

gen plus3 = myvar + 3

summarize

label variable myvar "sequence from 1 to 11"

label variable plus3 "myvar with 3 added"

clear

edit

* Change the working directory

cd "c:/chuck/NYU/Silver/Practicum/"

* Getting help

help mean

* Getting data into Stata

* Stata

use "https://clelandcm.github.io/Silver-Practicum/nhanes.dta", clear

* plain text

import delimited "https://clelandcm.github.io/Silver-Practicum/table1.txt", clear

* SPSS

import spss using "https://clelandcm.github.io/Silver-Practicum/hsb2.sav", clear

* MS-Excel

import excel using "https://clelandcm.github.io/Silver-Practicum/Female-Names.xlsx", firstrow clear

* Getting data out of Stata

* plain text

export delimited using "outcsv.csv", replace

* MS-Excel

export excel using "outxlsx.xlsx", firstrow(variables) replace // goes into working directory

* Stata

save "C:\chuck\NYU\Silver\Practicum\table1.dta", replace // explicit directory

* Data Management

* Labelling variables and values of variables

clear

input parent faminc hschool 
0 1 1
0 2 2
0 3 1
1 1 2
1 2 1
1 3 2
end

describe

codebook

tabulate parent

label variable parent "Mother or Father?"

label variable faminc "Family Income Category"

label variable hschool "High School of GED Completed?"

label define Mom_Dad_Label 0 "Mom" 1 "Dad"

label define faminc_Label 1 "<20k per year" 2 "20-50k per year" 3 ">50k per year"

label define Educ_Label 1 "No" 2 "Yes"

label values parent Mom_Dad_Label

label values faminc faminc_Label

label values hschool Educ_Label

describe 

codebook

tabulate parent

* Recoding

clear

input happy sad
4 1
2 2
1 5
4 3
4 3
4 2
1 4
2 1
5 1
4 5
end

recode sad (1=5) (2=4) (3=3) (4=2) (5=1), generate(sad_rev)

list

* Merging

* Append or stack variety (add cases)

input famid str4 name inc
2 "Art" 22000
1 "Bill" 30000
3 "Paul" 25000
end

save dads, replace // goes into working directory with .dta extension

list 

clear

input famid str4 name inc
1 "Bess" 15000
3 "Pat" 50000
2 "Amy" 18000
end

save moms, replace // goes into working directory with .dta extension

list 

use dads, clear 

append using moms 

list

* Match variety, 1:1 (add variables)

webuse autosize, clear
list

webuse autoexpense
list

webuse autosize
merge 1:1 make using "http://www.stata-press.com/data/r15/autoexpense"
list

* Match variety, m:1 ()

webuse dollars, clear
list

webuse sforce
list

merge m:1 region using "http://www.stata-press.com/data/r15/dollars"
list

* Select observations

use "bank.dta", clear

codebook sex // Females are sex=1

keep if sex == 1

describe

* Select variables

use "bank.dta", clear

describe

keep id sex age sal*

describe

* Reshaping, Wide to Long

use "https://stats.idre.ucla.edu/stat/stata/modules/faminc", clear 

list

reshape long faminc, i(famid) j(year)

list

* See 
* https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/ 
* for additional examples

* Reshaping, Long to Wide

import excel using "https://clelandcm.github.io/Silver-Practicum/Scores-Long.xlsx", firstrow clear

list

reshape wide Score, i(ID) j(Time)

list

clear

input ID WEIGHT CALORIES TIME
   1     200     3500      1 
   1     190     3300      2
   1     180     3100      3
   2     160     3000      1
   2     150     2900      2
   2     140     2800      3
end

list

reshape wide WEIGHT CALORIES, i(ID) j(TIME)

list

* Creating new variables from existing variables

use "https://clelandcm.github.io/Silver-Practicum/hsb2.dta", clear

generate total = read + write + math + science + socst

summarize

* Sorting

import excel using "https://clelandcm.github.io/Silver-Practicum/Scores-Long.xlsx", firstrow clear

list

gsort Score

list

clear

* Descending sort, multiple variables

input ID WEIGHT CALORIES TIME
   1     200     3500      1 
   1     190     3300      2
   1     180     3100      3
   2     160     3000      1
   2     150     2900      2
   2     140     2800      3
end

list

gsort -WEIGHT -CALORIES

list

* What's in my dataset?

webuse auto, clear

describe

* Plots
* Histogram

cd "c:/chuck/NYU/Silver/Practicum/"

import spss using "https://clelandcm.github.io/Silver-Practicum/hsb2.sav", clear

histogram WRITE

* Bar

import excel using "https://clelandcm.github.io/Silver-Practicum/Female-Names.xlsx", firstrow clear

graph bar (asis) Ngirls, over(Name, sort(Ngirls))

* Scatter

use "https://clelandcm.github.io/Silver-Practicum/hsb2.dta", clear

twoway (scatter read write)

* Scatter Enhanced

use "https://clelandcm.github.io/Silver-Practicum/bank.dta", clear

twoway scatter salbeg salnow, by(gender)

* Boxplots

use "https://clelandcm.github.io/Silver-Practicum/hsb2.dta", clear

graph box write, over(female)

* Analysis
* descriptive statistics

use "https://clelandcm.github.io/Silver-Practicum/hsb.dta", clear

summarize

* frequencies

use "https://clelandcm.github.io/Silver-Practicum/bank.dta", clear

table jobcat 

tabulate jobcat

* crosstabulation

use "https://clelandcm.github.io/Silver-Practicum/bank.dta", clear

tab gender jobcat, row col

* t-tests

use "https://clelandcm.github.io/Silver-Practicum/hsb.dta", clear

* one-sample

ttest write == 50

* paired samples

ttest read == write

* independent samples

ttest write, by(female)

ttest write, by(female) unequal welch

* correlation

use "https://clelandcm.github.io/Silver-Practicum/hsb2.dta", clear

pwcorr read write math science socst

pwcorr read write math science socst, obs sig

* linear regression

use "https://clelandcm.github.io/Silver-Practicum/hsb2.dta", clear

reg science math female socst read

* logistic regression

use "https://clelandcm.github.io/Silver-Practicum/lowbwt.dta", clear

label define Race_Label 1 "White" 2 "Black" 3 "Other"

label values RACE Race_Label

logit LOW AGE LWT i.RACE FTV

logit LOW AGE LWT i.RACE FTV, or

* Additional Resources

* https://www.stata.com/bookstore/gentle-introduction-to-stata/
* https://www.stata.com/bookstore/data-management-using-stata/



