#!/usr/bin/env bash

# This script will perform Level 1 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) activation
#		2) seed-based ppi
#		3) network-based ppi
# Note that activation analysis must be performed first.
# Seed-based PPI and Network PPI should follow activation analyses.

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
istartdatadir=/ZPOOL/data/projects/istart-data

# study-specific inputs
sm=5
sub=$1
run=$2
ppi=$3 # 0 for activation, otherwise seed region or network
TASK=$4
eig=$5

# set inputs and general outputs (should not need to change across studies in Smith Lab)
MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
mkdir -p $MAINOUTPUT
DATA=${istartdatadir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
NVOLUMES=`fslnvols $DATA`
CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_desc-fslConfounds.tsv
if [ ! -e $CONFOUNDEVS ]; then
	echo "missing confounds: $CONFOUNDEVS " >> ${maindir}/re-runL1.log
	exit # exiting to ensure nothing gets run without confounds
fi

# specify zero-padding or not or EVfiles
if [ "$TASK" == "mid" -o "$TASK" == "ugdg" ]; then
	EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run}
elif [ "$TASK" == "doors" -o "$TASK" == "socialdoors" -o "$TASK" == "sharedreward" ]; then
	EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/${TASK}/run-${run}
else
	echo "Task entered incorrectly; enter a proper ISTART taskname"
	exit
fi

# empty EVs (specific to this study)
EV_MISSED_TRIAL=${EVDIR}_decision-missed.txt
if [ -e $EV_MISSED_TRIAL ]; then
	SHAPE_MISSED_TRIAL=3
else
	SHAPE_MISSED_TRIAL=10
fi
EV_COMPN=${EVDIR}_event_computer_neutral.txt
if [ -e $EV_COMPN ]; then
	SHAPE_COMPN=3
else
	SHAPE_COMPN=10
fi
EV_STRANGERN=${EVDIR}_event_stranger_neutral.txt
if [ -e $EV_STRANGERN ]; then
	SHAPE_STRANGERN=3
else
	SHAPE_STRANGERN=10
fi
EV_FRIENDN=${EVDIR}_event_friend_neutral.txt
if [ -e $EV_FRIENDN ]; then
	SHAPE_FRIENDN=3
else
	SHAPE_FRIENDN=10
fi

# for eyeball~cerebellum analyses we only need seed-based ppi
TYPE=ppi
if [ ${eig} -eq 0 ]; then
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-1_type-${TYPE}_seed-${ppi}_run-${run}_sm-${sm}
else
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-1_type-${TYPE}_seed-${ppi}_run-${run}_sm-${sm}_eig
fi

# check for output and skip existing
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
	echo "missing feat output 2: $OUTPUT " >> ${maindir}/re-runL1.log
	rm -rf ${OUTPUT}.feat
fi

# create template and run analyses
ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-1_type-${TYPE}.fsf
OTEMPLATE=${MAINOUTPUT}/L1_sub-${sub}_task-${TASK}_model-1_type-${TYPE}_run-${run}.fsf

if [ ${eig} -eq 0 ]; then
	PHYS=${MAINOUTPUT}/ts_task-${TASK}_mask-${ppi}_run-${run}.txt
else
	PHYS=${MAINOUTPUT}/ts_task-${TASK}_mask-${ppi}_run-${run}_eig.txt
fi

MASK=${maindir}/masks/seed-${ppi}.nii.gz
if [ ${eig} -eq 0 ]; then
	fslmeants -i $DATA -o $PHYS -m $MASK
else
	fslmeants -i $DATA -o $PHYS -m $MASK --eig
fi
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
-e 's@EV_MISSED_TRIAL@'$EV_MISSED_TRIAL'@g' \
-e 's@SHAPE_MISSED_TRIAL@'$SHAPE_MISSED_TRIAL'@g' \
-e 's@PHYS@'$PHYS'@g' \
-e 's@SMOOTH@'$sm'@g' \
-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@EV_FRIENDN@'$EV_FRIENDN'@g' \
-e 's@SHAPE_FRIENDN@'$SHAPE_FRIENDN'@g' \
-e 's@EV_COMPN@'$EV_COMPN'@g' \
-e 's@SHAPE_COMPN@'$SHAPE_COMPN'@g' \
-e 's@EV_STRANGERN@'$EV_STRANGERN'@g' \
-e 's@SHAPE_STRANGERN@'$SHAPE_STRANGERN'@g' \
<$ITEMPLATE> $OTEMPLATE

feat $OTEMPLATE

# fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
mkdir -p ${OUTPUT}.feat/reg
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz

# delete unused files
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
