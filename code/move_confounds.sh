#!/usr/bin/env bash

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

for task in doors socialdoors mid sharedreward ugdg; do	
	for sub in `cat ${basedir}/code/newsubs.txt`; do
	  	for run in 1 2; do
	  		mkdir /ZPOOL/data/projects/istart-eyeballs/derivatives/fmriprep-confounds/sub-${sub}/
			cp /ZPOOL/data/projects/istart-data/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${task}_run-${run}_desc-confounds_timeseries.tsv /ZPOOL/data/projects/istart-eyeballs/derivatives/fmriprep-confounds/sub-${sub}/sub-${sub}_task-${task}_run-${run}_desc-confounds_timeseries.tsv
	  	done
	done
done