#!/usr/bin/env python
## finishVisit.py - miscellaneous jobs after phoSim is complete
##  - copy phoSim input files to project area
##  - clean up $SCRATCH
##  - reformat phoSim output image files for DM
##  - ingest reformatted phoSim output into DM friendly directory tree
##

import os,sys,shutil

print('\n\nWelcome to finishVisit.py\n========================\n')
rc = 0

## Setup logging, python style
import logging as log
log.basicConfig(stream=sys.stdout, format='%(asctime)s %(levelname)s in %(filename)s line %(lineno)s: %(message)s', level=log.INFO)

## Insert task config area for python modules (insert as 2nd element in sys.path)
sys.path.insert(1,os.getenv('DC2_CONFIGDIR'))

#############################################################################

## Copy phoSim input files to NERSC project area
scrDir = os.path.join(os.getenv('PHOSIM_SCR_ROOT'),os.getenv('DC2_SIXDIGSTREAM'))




## Clean up $SCRATCH.  This directory accumulates instance catalogs
## and bits of same, job submission files, parameter files, etc.  It
## all adds up to several GB per visit

if os.getenv('PHOSIM_SCR_CLEANUP') == '1':
    log.info('Cleaning up $SCRATCH: '+scrDir)
    shutil.rmtree(scrDir)
    pass




#############################################################################

## Reformat phoSim generated FITS image files

"""
To run the repackaging script, you'll need a copy of these two repos:

https://github.com/lsst/obs_lsstCam

https://github.com/LSSTDESC/desc_sim_utils

From bash, to create the runtime environment do

$ source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/setup.sh
$ source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/weekly/loadLSST.bash
$ setup lsst_distrib
$ setup -r <path_to>/desc_sim_utils
$ setup -r <path_to>/obs_lsstCam

For production, we'll have a setup script that you can use that will
setup everything with the desired package versions, but the master of
desc_sim_utils and obs_lsstCam should work for now.

If you have a directory with the lsst_a* files for a given visit, then
you can run the phosim_repackager.py script as per the help message:

$ phosim_repackager.py --help
usage: phosim_repackager.py [-h] [--out_dir OUT_DIR] [--verbose] visit_dir

Repackager for phosim amp files

positional arguments:
  visit_dir          visit directory

optional arguments:
  -h, --help         show this help message and exit
  --out_dir OUT_DIR  output directory
  --verbose          print time to process the data each sensor
"""




#############################################################################

## Ingest (reformatted) phoSim image files for DM use




#############################################################################

## Done.
log.info('All done.')
sys.exit(rc)
