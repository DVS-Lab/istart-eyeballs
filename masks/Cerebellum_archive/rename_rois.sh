#!/bin/bash

# Script for renaming cerebellum subregions, which are extracted by intensity number (code/extract_cb_subregions.sh)
# Jimmy Wyngaarden, 6 Dec 22

for cb in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do
	if [ ${cb} -eq 1 ]; then
		cp cerebellum_${cb}.nii.gz cerebellum_Left_IV.nii.gz
		echo "done cerebellum_Left_IV"
	fi
	if [ ${cb} -eq 2 ]; then
		cp cerebellum_${cb}.nii.gz cerebellum_Right_IV.nii.gz
		echo "done cerebellum_Right_IV"
	fi
	if [ ${cb} -eq 3 ]; then
		cp cerebellum_${cb}.nii.gz cerebellum_Left_V.nii.gz
		echo "done cerebellum_Left_V"
	fi
	if [ ${cb} -eq 4 ]; then
		cp cerebellum_${cb}.nii.gz cerebellum_Right_V.nii.gz
		echo "done cerebellum_Right_V"
	fi

	if [ ${cb} -eq 5 ] || [ ${cb} -eq 6 ] || [ ${cb} -eq 7 ]; then
		roi="VI"	
		if [ ${cb} -eq 5 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 6 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 7 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi

	if [ ${cb} -eq 8 ] || [ ${cb} -eq 9 ] || [ ${cb} -eq 10 ]; then
		roi="Crus_I"		
		if [ ${cb} -eq 8 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 9 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 10 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi
	
	if [ ${cb} -eq 11 ] || [ ${cb} -eq 12 ] || [ ${cb} -eq 13 ]; then
		roi="Crus_II"		
		if [ ${cb} -eq 11 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 12 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 13 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi
	
	if [ ${cb} -eq 14 ] || [ ${cb} -eq 15 ] || [ ${cb} -eq 16 ]; then
		roi="VIIb"		
		if [ ${cb} -eq 14 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 15 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 16 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi	
	
	if [ ${cb} -eq 17 ] || [ ${cb} -eq 18 ] || [ ${cb} -eq 19 ]; then
		roi="VIIIa"		
		if [ ${cb} -eq 17 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 18 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 19 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi		
	
	if [ ${cb} -eq 20 ] || [ ${cb} -eq 21 ] || [ ${cb} -eq 22 ]; then
		roi="VIIIb"		
		if [ ${cb} -eq 20 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 21 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 22 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi	
	
	if [ ${cb} -eq 23 ] || [ ${cb} -eq 24 ] || [ ${cb} -eq 25 ]; then
		roi="IX"		
		if [ ${cb} -eq 23 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 24 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 25 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi	
		
	if [ ${cb} -eq 26 ] || [ ${cb} -eq 27 ] || [ ${cb} -eq 28 ]; then
		roi="X"		
		if [ ${cb} -eq 26 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Left_${roi}.nii.gz
			echo "done cerebellum_Left_${roi}"
		fi
		if [ ${cb} -eq 27 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Vermis_${roi}.nii.gz
			echo "done cerebellum_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../left_hemisphere.nii.gz cerebellum_Left_Vermis_${roi}.nii.gz
			echo "done cerebellum_Left_Vermis_${roi}"
			fslmaths cerebellum_Vermis_${roi}.nii.gz -mul ../right_hemisphere.nii.gz cerebellum_Right_Vermis_${roi}.nii.gz
			echo "done cerebellum_Right_Vermis_${roi}"
		fi
		if [ ${cb} -eq 28 ]; then
			cp cerebellum_${cb}.nii.gz cerebellum_Right_${roi}.nii.gz
			echo "done cerebellum_Right_${roi}"
		fi
	fi	
done



