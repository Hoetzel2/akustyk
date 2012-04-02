call createTable
call getChi
procedure createTable
tableMain = Create TableOfReal... table 2 3
Set row label (index)... 1 f
Set row label (index)... 2 m
Set column label (index)... 1 bike
Set column label (index)... 2 car
Set column label (index)... 3 walk
Set value... 1 1 4
Set value... 1 2 20
Set value... 1 3 45
Set value... 2 1 13
Set value... 2 2 25
Set value... 2 3 23
endproc
procedure getChi
Erase all
clearinfo
Select outer viewport... 0 6 0 1.5
Draw as numbers... 1 0 free 5
Text top... yes TABLE OF OBSERVED COUNTS
Copy... tablePct
tablePct = selected("TableOfReal")
nrow = Get number of rows
ncol = Get number of columns
for i from 1 to nrow
	rowSum'i' = 0
endfor
for i from 1 to ncol
	for j from 1 to nrow
		x'j' = Get value... j i
		rowSum'j' += x'j'
	endfor
endfor
for i from 1 to ncol
	select tableMain
	for j from 1 to nrow
		row'i'_'j' = Get value... j i
		select tablePct
		Set value... j i (row'i'_'j'  / rowSum'j') * 100
	endfor
endfor
Select outer viewport... 0 6 1.5 3
Draw as numbers... 1 0 free 5
Text top... yes TABLE OF OBSERVED PERCENTS
select tableMain
Copy... tableExp
tableExp = selected("TableOfReal")
for i from 1 to nrow
	for j from 1 to ncol
		colSum'j' = 0
	endfor
	rowSum'i' = 0
endfor
total = 0
for i from 1 to nrow
	for j from 1 to ncol
		colSum'j' += Get value... i j
		total += Get value... i j
	endfor
endfor
for i from 1 to ncol
	for j from 1 to nrow
		rowSum'j' += Get value... j i
	endfor
endfor
select tableExp
for i from 1 to nrow
	for j from 1 to ncol
		Set value... i j (rowSum'i' * colSum'j' / total)
	endfor
endfor
Select outer viewport... 0 6 3 4.5
Draw as numbers... 1 0 free 5
Text top... yes TABLE OF EXPECTED COUNTS
select tableExp
Copy... chiTable
chiTable = selected("TableOfReal")
chi = 0
for i from 1 to nrow
	for j from 1 to ncol
		select tableMain
		temp1 = Get value... i j
		select tableExp
		temp2 = Get value... i j
		select chiTable
		Set value... i j (temp1 - temp2)^2 / temp2
		chi += Get value... i j
	endfor
endfor
Select outer viewport... 0 6 4.5 6
Draw as numbers... 1 0 free 5
Text top... yes TABLE OF VALUES TO CALCULATE CHISQ VALUE
Select outer viewport... 0. 6 0 6
df = ncol - 1
chiP = 1 - chiSquareP(chi, df)
printline
printline Chi-Square = 'chi:6'
printline p = 'chiP:6'
endproc
