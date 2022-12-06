for cb in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do
	#fslmaths Cerebellum-MNIflirt-maxprob-thr25-2mm.nii.gz -thr ${cb} -uthr ${cb} cerebellum_${cb}.nii.gz
	#echo "done cerebellum_${cb}"
	
	echo "<voxels> and <volume> (non-zero voxels) for cerebellum_${cb}"
	fslstats cerebellum_${cb}.nii.gz -V
done