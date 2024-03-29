#!/bin/bash

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=1

#for task in socialdoors; do
#for task in doors socialdoors mid sharedreward ugdg; do
for task in socialdoors; do
	for ppi in "eyeball_right" "eyeball_left"; do
		#for sub in 1303 3101 3116 3122 3125 3140 3143 3152 3166 3167 3170 3173 3176 3189 3190 3199 3200 3206 3210 3212 3218 3220 3223; do
		#for sub in 1001 1003 1004 ; do
		for sub in 1253 1282; do
	  		#for run in `seq $nruns`; do
	  		for run in 1 2; do
	  			for eig in 1; do

		  				# Manages the number of jobs and cores
		  				SCRIPTNAME=${basedir}/code/L1stats.sh
	  					NCORES=10
	  					while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    					sleep 5s
	  					done

	  				bash $SCRIPTNAME $sub $run $ppi $task $eig &
	  				sleep 1s
	  				
				done
			done	  	
	  	done
	done
done
