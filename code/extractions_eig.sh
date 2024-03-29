#!/bin/bash

# Script for extracting CB connectivity values for ISTART tasks
# Jimmy Wyngaarden, Dec 2022

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

for task in doors mid sharedreward socialdoors ugdg; do
	echo ${task}	
	for cb in `cat ${basedir}/code/CB_ROIs.txt`; do 
		echo ${cb}		
		for sub in `cat ${basedir}/code/gsr_data_${task}.csv`; do		
				
			# Read in sub ID & usable run (1=1, 2=2, 3=both)				
			IFS=',' read run gsr tsnr fd_mean sub <<< $sub
			echo ${sub} ${run}
				
			# Specify phys cope number based on task
			if [ "${task}" == "doors" ] || [ "${task}" == "socialdoors" ]; then
				cnum=5				
			elif [ "${task}" == "mid" ]; then
				cnum=15
			elif [ "${task}" == "ugdg" ]; then
				cnum=17
			elif [ "${task}" == "sharedreward" ]; then
				cnum=24
			fi				
				
			# Define phys copes for left and right when usable run = 1 or 2
			L1physLeft=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_left_run-${run}_sm-5.feat/stats/zstat${cnum}.nii.gz	
			L1physRight=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_right_run-${run}_sm-5.feat/stats/zstat${cnum}.nii.gz			
				
			# Define phys copes for left and right when both runs are usable (run = 3)
			L2physLeft=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_left_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
			L2physRight=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_right_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
				
			# Smoothing kernel is flagged as 6 (despite being set at 5!) for doors & socialdoors, so they get specified here
			if [ "${task}" == "doors" ] || [ "${task}" == "socialdoors" ]; then
			 	L1physLeft=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_left_run-${run}_sm-6.feat/stats/zstat${cnum}.nii.gz	
				L1physRight=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_right_run-${run}_sm-6.feat/stats/zstat${cnum}.nii.gz
			fi								
				
			# Define output directory
			outputdir=${basedir}/derivatives/extractions_eig/${task}
				
			# Do extraction: First, determine whether usable data comes from run-1, run-2, or both (run = 3)		
			if [ $run -eq 1 ]	|| [ $run -eq 2 ]; then			
					
				# Check to confirm that phys file exists
				if [ -e $L1physRight ]; then	
									
					echo "Extracting left eye from left ${cb} for ${sub} ${task} run-${run}"							
					fslmeants -i ${L1physLeft} -eig -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb_eig-${cb}.txt -m ${basedir}/masks//cerebellum_Left_${cb}.nii.gz\
					#fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz

					echo "Extracting right eye from right ${cb} for ${sub} ${task} run-${run}"							
					fslmeants -i ${L1physRight} -eig -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					#fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz

					echo "Extracting contralateral signal for ${sub} ${task} in ${cb}"
					fslmeants -i ${L1physLeft} -eig -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					fslmeants -i ${L1physRight} -eig -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					
				# If phys file can't be found, print error message					
				else
					echo "Cannot find L1stats file ${L1physRight}"
				fi
				
			# Repeat extractions for subs that have usable data from both runs
			elif [ $run -eq 3 ]; then		
				if [ -e $L2physRight ]; then										

					echo "Extracting Left ${cb} from ${sub} ${task} from L2stats"							
					fslmeants -i ${L2physLeft} --eig -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					#fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz

					echo "Extracting Right ${cb} from ${sub} ${task} from L2stats"
					fslmeants -i ${L2physRight} --eig -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					#fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz				

					echo "Extracting contralateral signal for ${sub} ${task} in ${cb}"
					fslmeants -i ${L2physLeft} --eig -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					fslmeants -i ${L2physRight} --eig -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb_eig-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz				
				
				else
					echo "Cannot find L2stats file ${L2physRight}"
				fi			
				
			# If run is set as something other than 1, 2, or 3, print error message				
			else
				echo "Cannot find run information"
			fi
		done
	done
done

# Check output in istart-eyeballs/derivatives/extractions