#!/bin/bash

# Script for extracting CB connectivity values for ISTART tasks
# Jimmy Wyngaarden, Dec 2022

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

# Loop
#for task in mid; do
for task in doors socialdoors; do #mid sharedreward ugdg; do
	echo ${task}	
	for cb in `cat ${basedir}/code/CB_ROIs.txt`; do 
	#for cb in "Crus_II"; do
		echo ${cb}		
	
			for sub in `cat ${basedir}/code/gsr_data_${task}.csv`; do
			#for sub in 3101; do			
				
				# Read in sub ID, gsr, & usable run (1=1, 2=2, 3=both)				
				IFS=',' read run gsr tsnr fd_mean sub <<< $sub
				echo ${sub} ${run}
				
				# Specify phys cope based on task
				if [ "${task}" == "doors" ] || [ "${task}" == "socialdoors" ]; then
					cnum=5				
				elif [ "${task}" == "mid" ]; then
					cnum=15
				elif [ "${task}" == "ugdg" ]; then
					cnum=17
				elif [ "${task}" == "sharedreward" ]; then
					cnum=24
				fi				
				
				# Define phys copes for left and right
				L1physLeft=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_left_run-${run}_sm-5.feat/stats/zstat${cnum}.nii.gz	
				L1physRight=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_right_run-${run}_sm-5.feat/stats/zstat${cnum}.nii.gz			
				
				L2physLeft=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_left_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
				L2physRight=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_right_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
				
				if [ "${task}" == "doors" ] || [ "${task}" == "socialdoors" ]; then
				 	L1physLeft=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_left_run-${run}_sm-6.feat/stats/zstat${cnum}.nii.gz	
					L1physRight=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_right_run-${run}_sm-6.feat/stats/zstat${cnum}.nii.gz
				fi								
				
				# Define output directory
				outputdir=${basedir}/derivatives/extractions/${task}
				
				# Do extraction		
				if [ $run -eq 1 ]	|| [ $run -eq 2 ]; then			
					
					# Check if phys file exists
					if [ -e $L1physRight ]; then					
						if	[ "${cb}" == "IV" ] || [ "${cb}" == "V" ]; then
							echo "Extracting Left ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							echo "Extracting Left ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
						else				
							echo "Extracting Left ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							echo "Extracting Left ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							#fslmeants -i ${phys} -o ${outputdir}/sub-${sub}_task-${task}_vermis_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Vermis_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz			
							#fslmeants -i ${phys} -o ${outputdir}/sub-${sub}_task-${task}_vermis_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Vermis_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} run-${run}"							
							fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz			
						fi					
					else
						echo "Cannot find L1stats file ${L1physRight}"
					fi

				elif [ $run -eq 3 ]; then		
					if [ -e $L2physRight ]; then				
						if	[ "${cb}" == "IV" ] || [ "${cb}" == "V" ]; then							
							echo "Extracting Left ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} from L2stats"
							fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
							echo "Extracting Left ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} from L2stats"
							fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
						else				
							echo "Extracting Left ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							#fslmeants -i ${phys} -o ${outputdir}/sub-${sub}_task-${task}_vermis_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Vermis_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
							echo "Extracting Left ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
							#fslmeants -i ${phys} -o ${outputdir}/sub-${sub}_task-${task}_vermis_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Vermis_${cb}.nii.gz
							echo "Extracting Right ${cb} from ${sub} ${task} from L2stats"							
							fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz							
						fi
					else
						echo "Cannot find L2stats file ${L2physRight}"
					fi			
				else
					echo "Cannot find run information"
				fi

			done
	done
done