#!/bin/bash

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=2

#for task in socialdoors; do
for task in mid ugdg doors socialdoors sharedreward ; do
	for ppi in "eyeball_left" "eyeball_right"; do
		#for sub in 1019; do
		#for sub in `cat ${basedir}/code/newsubs.txt`; do
		for sub in 1001; do	  	
	  		for run in `seq $nruns`; do

		  		# Manages the number of jobs and cores
		  		SCRIPTNAME=${basedir}/code/L1stats.sh
	  			NCORES=10
	  			while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    			sleep 5s
	  			done

	  		bash $SCRIPTNAME $sub $run $ppi $task &
	  		sleep 1s

			done	  	
	  	done
	done
done
