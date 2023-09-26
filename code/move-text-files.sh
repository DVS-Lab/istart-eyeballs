#!/bin/bash

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

for task in doors; do
#for task in doors socialdoors mid sharedreward ugdg; do
	for ppi in "eyeball_left" "eyeball_right"; do
		for sub in `cat ${basedir}/code/newsubs.txt`; do
	  		for run in 1 2; do
	  			for eig in 1; do
	  				
	  				# Check for existing output dir & write one if it's not already there
	  				#if [ -e ${basedir}/derivatives/extractEyes/sub-${sub}/ ]; then
					#	echo "extractEyes/sub-${sub} already exists"
					#else	  					
	  				#	mkdir ${basedir}/derivatives/extractEyes/sub-${sub}
	  				#fi
	  				
	  				# Check for eig
	  				if [ ${eig} -eq 0 ]; then
						input=${basedir}/derivatives/archive_fsl-09252023/sub-${sub}/ts_task-${task}_mask-${ppi}_run-${run}.txt
						output=${basedir}/derivatives/extractEyes/sub-${sub}/ts_task-${task}_mask-${ppi}_run-${run}.txt			
					else
						input=${basedir}/derivatives/fsl/sub-${sub}/ts_task-${task}_mask-${ppi}_run-${run}_eig.txt
						output=${basedir}/derivatives/extractEyes/sub-${sub}/ts_task-${task}_mask-${ppi}_run-${run}_eig.txt		
					fi			
	  				
	  				# Copy the file
	  				cp -r $input $output
	  				
	  			done
	  		done
	  	done
	done
done