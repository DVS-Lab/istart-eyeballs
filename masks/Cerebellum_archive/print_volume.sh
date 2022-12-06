#!/bin/bash

# Script for printing out number of voxels & volume of CB subregions
# Usage to save output in a csv file: bash print_volume.sh > roi_volumes.csv 
# Jimmy Wyngaarden, 6 Dec 22

for cb in "IV" "V" "VI" "Crus_I" "Crus_II" "VIIb" "VIIIa" "VIIIb" "IX" "X"; do
	for hem in "Left" "Right" "Vermis"; do			
		if [ -e cerebellum_${hem}_${cb}.nii.gz ]; then		
			echo "${hem} ${cb} <voxels> and <volume> (non-zero voxels)"
			fslstats cerebellum_${hem}_${cb}.nii.gz -V
		else
			echo "cerebellum_${hem}_${cb}.nii.gz does not exist"
		fi
	done
done

#for cb in "IV" "V" "VI" "Vermis_VI" "Crus_I" "Vermis_Crus_I" "Crus_II" "Vermis_Crus_II" "VIIb" "Vermis_VIIb" "VIIIa" "Vermis_VIIIa" "VIIIb" "Vermis_VIIIb" "IX" "Vermis_IX" "X" "Vermis_X"; do
	# Skip this if statement if you want to look at bilateral vermis; leave it if you want to look at full vermis	
	if [ ${cb} == "*Vermis*" ]; then
		echo	"${cb} <voxels> and <volume> (non-zero voxels)"
		fslstats cerebellum_${cb}.nii.gz -V
	else	
		for hem in "Left" "Right"; do			
			echo "${hem} ${cb} <voxels> and <volume> (non-zero voxels)"
			fslstats cerebellum_${hem}_${cb}.nii.gz -V
		done
	fi
done