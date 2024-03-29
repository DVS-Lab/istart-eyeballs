#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# setting inputs and common variables
sub=$1
type=$2
task=$3
eig=$4
sm=5 # edit if necessary
MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
model=1
NCOPES=5


# --- start EDIT HERE start: exceptions and conditionals for the task

#if [ $sub -eq 1001 ]; then # bad data
#	echo "skipping sub-${sub} for task-${task}"
#	exit
#fi

# hopefully temporary:
#if [ $sub -eq 1001 ]; then # bad data
#	echo "skipping sub-${sub} for task-${task}"
#	exit
#fi

# ppi has more contrasts than act (phys), so need a different L2 template

ITEMPLATE=${maindir}/templates/L2_task-${task}_model-${model}_type-ppi.fsf
let NCOPES=${NCOPES}+1 # add 1 since we tend to only have one extra contrast for PPI

if [ ${eig} -eq 0 ]; then
	INPUT1=${MAINOUTPUT}/L1_task-${task}_model-${model}_type-${type}_run-1_sm-${sm}.feat
	INPUT2=${MAINOUTPUT}/L1_task-${task}_model-${model}_type-${type}_run-2_sm-${sm}.feat
else
	INPUT1=${MAINOUTPUT}/L1_task-${task}_model-${model}_type-${type}_run-1_sm-${sm}_eig.feat
	INPUT2=${MAINOUTPUT}/L1_task-${task}_model-${model}_type-${type}_run-2_sm-${sm}_eig.feat
fi

# --- end EDIT HERE end: exceptions and conditionals for the task; need to exclude bad/missing runs


# check for existing output and re-do if missing/incomplete
if [ ${eig} -eq 0 ]; then
	OUTPUT=${MAINOUTPUT}/L2_task-${task}_model-${model}_type-${type}_sm-${sm}
else
	OUTPUT=${MAINOUTPUT}/L2_task-${task}_model-${model}_type-${type}_sm-${sm}_eig
fi

if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then # check last (act) or penultimate (ppi) cope
	echo "skipping existing output"
else
	echo "re-doing: ${OUTPUT}" >> re-runL2.log
	rm -rf ${OUTPUT}.gfeat

	# set output template and run template-specific analyses
	OTEMPLATE=${MAINOUTPUT}/L2_task-${task}_model-${model}_type-${type}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

	# delete unused files
	for cope in `seq ${NCOPES}`; do
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
	done

fi
