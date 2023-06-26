#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# the "type" variable below is setting a path inside the main script
for type in "ppi_seed-eyeball_left" "ppi_seed-eyeball_right"; do
	#for sub in `cat ${scriptdir}/newsubs.txt`; do
	for sub in 1002 1007; do	
		#for task in "sharedreward" "mid" "ugdg"; do #"sharedreward"; do
		for task in sharedreward; do		
			for eig in 0; do
				# Manages the number of jobs and cores
  				SCRIPTNAME=${maindir}/code/L2stats.sh
  				NCORES=5
  				while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    					sleep 1s
  				done
  				bash $SCRIPTNAME $sub $type $task $eig &
  				sleep 1s
			done
		done
	done
done