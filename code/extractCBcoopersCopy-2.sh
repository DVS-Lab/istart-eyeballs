#!/bin/bash

# Script for extracting CB connectivity values for ISTART tasks
# Jimmy Wyngaarden, Dec 2022

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

for task in doors socialdoors mid sharedreward ugdg; do
#for task in ugdg; do
	echo ${task}	
	for cb in `cat ${basedir}/code/CB_ROIs.txt`; do 
		echo ${cb}		
		for sub in `cat ${basedir}/code/usable-data/usable-data_task-${task}.csv`; do		
				
			# Read in sub ID & usable run (1=1, 2=2, 3=both)				
			IFS=',' read sub run <<< $sub
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
			# With Eig 
			#L1physLeft_eig=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_left_run-${run}_sm-5_eig.feat/stats/zstat${cnum}.nii.gz	
			#L1physRight_eig=${basedir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-ppi_seed-eyeball_right_run-${run}_sm-5_eig.feat/stats/zstat${cnum}.nii.gz			
				
			# Define phys copes for left and right when both runs are usable (run = 3)
			L2physLeft=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_left_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
			L2physRight=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_right_sm-5.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
			# With eig 
			#L2physLeft_eig=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_left_sm-5_eig.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz				
			#L2physRight_eig=${basedir}/derivatives/fsl/sub-${sub}/L2_task-${task}_model-1_type-ppi_seed-eyeball_right_sm-5_eig.gfeat/cope${cnum}.feat/stats/zstat1.nii.gz					
				
			# Define output directory
			outputdir=${basedir}/derivatives/imaging_plots/${task}
				
			# Perform extraction: First, determine whether usable data comes from run-1, run-2, or both (run = 3), or if data is missing (0) 	
			if [ $run -eq 1 ]	|| [ $run -eq 2 ]; then			
					
				# Check to confirm that phys file exists
				if [ -e $L1physRight ]; then	
					echo "For sub-${sub}_task-${task}: Extracting eye-left hemi-left from ${cb} from run-${run}"							
					fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					echo "For sub-${sub}_task-${task}: Extracting eye-right hemi-right from ${cb} from run-${run}"							
					fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					echo "For sub-${sub}_task-${task}: Extracting eye-left hemi-right from ${cb} from run-${run}"
					fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					echo "For sub-${sub}_task-${task}: Extracting eye-right hemi-left from ${cb} from run-${run}"
					fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
									
				# If phys file can't be found, print error message					
				else
					echo "Cannot find L1stats file ${L1physRight}"
				fi
				
				#if [ -e $L1physRight_eig ]; then	
					#echo "Extracting left eye from left ${cb} for ${sub} ${task} run-${run}_eig"							
					#fslmeants -i ${L1physLeft_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz\
					#fslmeants -i ${L1physLeft} -o ${outputdir}/sub-${sub}_task-${task}_left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					#echo "Extracting right eye from right ${cb} for ${sub} ${task} run-${run}_eig"							
					#fslmeants -i ${L1physRight_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					#fslmeants -i ${L1physRight} -o ${outputdir}/sub-${sub}_task-${task}_right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					#echo "Extracting contralateral signal for ${sub} ${task} run-${run} in ${cb}_eig"
					#fslmeants -i ${L1physLeft_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					#fslmeants -i ${L1physRight_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
									
				# If phys file can't be found, print error message					
				#else
					#echo "Cannot find L1stats file ${L1physRight_eig}"
				#fi
				
			# Repeat extractions for subs that have usable data from both runs
			elif [ $run -eq 3 ]; then		
				if [ -e $L2physRight ]; then										
					echo "For sub-${sub}_task-${task}: Extracting eye-left hemi-left from ${cb} from L2stats"							
					fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					echo "For sub-${sub}_task-${task}: Extracting eye-right hemi-right from ${cb} from L2stats"
					fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					echo "For sub-${sub}_task-${task}: Extracting eye-left hemi-right from ${cb} from L2stats"
					fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					echo "For sub-${sub}_task-${task}: Extracting eye-right hemi-left from ${cb} from L2stats"					
					fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz				
				
				else
					echo "Cannot find L2stats file ${L2physRight}"
				fi		
				
				#if [ -e $L2physRight_eig ]; then										

					#echo "Extracting Left ${cb} from ${sub} ${task}_eig from L2stats"							
					#fslmeants -i ${L2physLeft_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-left_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					#fslmeants -i ${L2physLeft} -o ${outputdir}/sub-${sub}_task-${task}_left_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz
					#echo "Extracting Right ${cb} from ${sub} ${task}_eig from L2stats"
					#fslmeants -i ${L2physRight_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-right_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz
					#fslmeants -i ${L2physRight} -o ${outputdir}/sub-${sub}_task-${task}_right_cb-${cb}.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz				
					#echo "Extracting contralateral signal for ${sub} ${task}_eig in ${cb}"
					#fslmeants -i ${L2physLeft_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-left_hemi-right_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Right_${cb}.nii.gz					
					#fslmeants -i ${L2physRight_eig} -o ${outputdir}/sub-${sub}_task-${task}_eye-right_hemi-left_cb-${cb}_eig.txt -m ${basedir}/masks/Cerebellum_archive/cerebellum_Left_${cb}.nii.gz				
				
				#else
				#	echo "Cannot find L2stats file ${L2physRight_eig}"
				#fi				
				
			# If run is set as something other than 1, 2, or 3, print error message				
			elif [ $run -eq 0 ]; then
				echo "No data for this subject: sub-${sub}_task-${task}"
			fi
		done
	done
done

# Check output in istart-eyeballs/derivatives/extractions