#!/bin/bash

module load nco

# --------------------- USER SPECIFIED ---------------------
caseName='b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.115'
histDir='/glade/scratch/cesmsf/archive/b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.115/atm/hist/'
outDir='/glade/work/sglanvil/CCR/CCRdiags_OG/out/'
# note, add '/' to end of histDir and outDir
# ----------------------------------------------------------

cat ~nanr/diags/ccr/all_diag_fields.* | sort | uniq > fields_all # Only needs to happen once.
firstFile=$(ls ${histDir}*.cam.h0.* | head -n 1)
ncdump -h $firstFile | grep :long_name | sed 's/:long_name.*//' | sed 's/^[ \t]*//' > fields_avail
comm -12 <(sort fields_avail) <(sort fields_all) > fields_intersect 
varList=$(cat fields_intersect)
varList=$(echo $varList | sed 's/ /,/g')
echo
echo Variables extracted: 
echo $varList
echo
echo -------------------------------

firstDate=$(ls ${histDir}*.cam.h0.* | head -n 1 | sed 's/.*cam\.h0\.//' | sed 's/\.nc//')
lastDate=$(ls ${histDir}*.cam.h0.* | tail -n 1 | sed 's/.*cam\.h0\.//' | sed 's/\.nc//')
firstYear=${firstDate:0:4}
lastYear=${lastDate:0:4}
echo
echo First year: $firstYear
echo Last year:  $lastYear
echo
echo -------------------------------

for iyear in $(eval echo "{$firstYear..$lastYear}"); do
	monthsInYear=$(ls ${histDir}${caseName}.cam.h0.${iyear}-??.nc | wc -l)
	if [ $monthsInYear -eq 12 ]; then
		echo $iyear "has 12 months --------------> PROCESS"
		ncra -O -v ${varList[@]} ${histDir}${caseName}.cam.h0.${iyear}-??.nc ${outDir}${caseName}_ANN_${iyear}.nc
	else
		echo $iyear "does not have 12 months ----> SKIP"
	fi
done

ls -1 ${outDir}${caseName}_ANN_*.nc > ${outDir}ann.files

