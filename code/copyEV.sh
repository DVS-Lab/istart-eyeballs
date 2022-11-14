#!/bin/bash

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"



for task in mid sharedreward ugdg ; do
	
		
	for sub in `cat ${basedir}/code/newsubs.txt`; do
	  		cp -r /data/projects/istart-${task}/derivatives/fsl/EVfiles/sub-${sub}/${task} ${basedir}/derivatives/fsl/EVfiles/sub-${sub}/
	  		
	done	  	
done