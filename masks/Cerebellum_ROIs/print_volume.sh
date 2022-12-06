for cb in "crus_II" "crus_I" "IX" "vermis_crus_II" "vermis_crus_I" "vermis_IX" "vermis_VIIb" "vermis_VIIIa" "vermis_VIIIb" "vermis_VI" "vermis_X" "VIIb" "VIIIa" "VIIIb" "VI" "X"; do
	for hem in "left" "right"; do	
		echo "${cb} ${hem} <voxels> and <volume> (non-zero voxels)"
		fslstats cerebellum_${cb}_${hem}.nii.gz -V
	done
done