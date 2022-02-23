#!/bin/bash

module load nco

# --------------------- USER SPECIFIED ---------------------
caseName='b.e11.B1850LENS.f09_g16.aaer.RCP85.003'
histDir='/glade/scratch/sglanvil/holdingCell/testCCRdiags/'
outDir='/glade/work/sglanvil/CCR/CCRdiags_OG/out/'
varList=('TS','QFLX','PRECC')
# ----------------------------------------------------------

firstDate=$(ls ${histDir} | head -n 1 | sed 's/.*cam\.h0\.//' | sed 's/\.nc//')
lastDate=$(ls ${histDir} | tail -n 1 | sed 's/.*cam\.h0\.//' | sed 's/\.nc//')

firstYear=${firstDate:0:4}
lastYear=${lastDate:0:4}

for iyear in $(eval echo "{$firstYear..$lastYear}"); do
	monthsInYear=$(ls ${histDir}${caseName}.cam.h0.${iyear}-??.nc | wc -l)
	if [ $monthsInYear -eq 12 ]; then
		echo ${iyear} "has 12 months --------------> PROCESS"
		ncra -O -v ${varList[@]} ${histDir}${caseName}.cam.h0.${iyear}-??.nc ${outDir}${caseName}_ANN_${iyear}.nc
	else
		echo ${iyear} "does not have 12 months ----> SKIP"
	fi
done



