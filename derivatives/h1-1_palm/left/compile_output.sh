#!/bin/bash

# compile PALM output into a single file

for c in 1 2; do
	echo " "	
	echo "doors, socialdoors, ugdg, mid, sharedreward"
	echo "IV, V, VI, Crus_I, Crus_II, VIIb, VIIIa, VIIIb, IX, X, Vermis_VI, Vermis_VIIIa, Vermis_VIIIb, Vermis_IX"
	for s in tstat tstat_uncp tstat_fwep tstat_cfwep; do
	
		echo _dat_${s}_c${c}.csv
		cat _dat_${s}_c${c}.csv
	
	done
done
