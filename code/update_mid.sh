#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

for sub in `cat ${scriptdir}/newsubs.txt`; do
	if [ -e ${maindir}/derivatives/fsl/sub-${sub}/L1_task-mid_model-1_type-ppi_seed-eyeball_left_run-1_sm-6+.feat ]; then
		#mkdir ${maindir}/derivatives/fsl/sub-${sub}/mid_archive	
		for ppi in "eyeball_left" "eyeball_right"; do	
			for run in 1 2; do			
				# Move old mid feat dirs into archive			
				#mv ${maindir}/derivatives/fsl/sub-${sub}/L1_task-mid_model-1_type-ppi_seed-${ppi}_run-${run}_sm-6.feat ${maindir}/derivatives/fsl/sub-${sub}/mid_archive/
				# Rename new mid feat dirs
				mv ${maindir}/derivatives/fsl/sub-${sub}/L1_task-mid_model-1_type-ppi_seed-${ppi}_run-${run}_sm-6+.feat ${maindir}/derivatives/fsl/sub-${sub}/L1_task-mid_model-1_type-ppi_seed-${ppi}_run-${run}_sm-6.feat	
			done
		done
	else
		echo "no MID for sub-${sub}"
	fi	
done