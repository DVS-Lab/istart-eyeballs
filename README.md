# ISTART-eyeballs: Characterizing the effects of Nyquist ghosting in task-dependent cerebellar connectivity
This repository contains code related to our project investigating the effects of nyquist ghosting from the eyeballs on task-dependent signal in the cerebellum. All hypotheses and analysis plans were pre-registered on osf (https://osf.io/sd395/) in fall semester 2022 and analyses commenced on shortly thereafter. Imaging data will be shared via [OpenNeuro][openneuro] when the manuscript is posted on bioRxiv.


## A few prerequisites and recommendations
- Understand BIDS and be comfortable navigating Linux
- Install [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
- Install [miniconda or anaconda](https://stackoverflow.com/questions/45421163/anaconda-vs-miniconda)


## Notes on repository organization and files
- Raw DICOMS (an input to heudiconv) are private and only accessible locally (Smith Lab Linux: /data/sourcedata)
- Some of the contents of this repository are not tracked (.gitignore) because the files are large and we do not yet have a nice workflow for datalad. These folders include `/data/sourcedata` (dicoms) and parts of `bids` and `derivatives`.
- Tracked folders and their contents:
  - `code`: analysis code
  - `templates`: fsf template files used for FSL analyses
  - `masks`: images used as masks, networks, and seed regions in analyses
  - `derivatives`: derivatives from analysis scripts, but only text files (re-run script to regenerate larger outputs)


## Basic commands to reproduce our analyses
```
# get code and data (two options for data)
git clone https://github.com/DVS-Lab/istart-socdoors
cd  istart-socdoors

rm -rf bids # remove bids subdirectory since it will be replaced below
# can this be made into a sym link?

datalad clone https://github.com/OpenNeuroDatasets/ds003745.git bids
# the bids folder is a datalad dataset
# you can get all of the data with the command below:
datalad get sub-*

# run preprocessing and generate confounds and timing files for analyses
bash code/run_fmriprep.sh
python code/MakeConfounds.py --fmriprepDir="derivatives/fmriprep"
bash code/run_gen3colfiles.sh

# run statistics
bash code/run_L1stats.sh
bash code/run_L2stats.sh
```

[openneuro]: https://openneuro.org/
