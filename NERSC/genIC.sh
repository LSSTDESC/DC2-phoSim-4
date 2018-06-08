#!/bin/bash
## genIC.sh - setup and run the DC2 instanceCatalog generator for the DC2-phoSim-2 task

echo
echo "==============================================================="
echo "Entering genIC.sh - setup and run DC2 instanceCatalog generator"
date

## Handle incoming instCat generator command options
options=$@

## Remove command line parameters so as to not confuse the stack setup script :(
shift $#


## Setup (revamped, 2/15/2018)
cmd="source ${PHOSIM_IC_SETUP}"
echo $cmd
eval $cmd

echo printenv PYTHONPATH
printenv PYTHONPATH

## Emergency add (2/20/2018 21:52)
export HDF5_USE_FILE_LOCKING=FALSE

## Display the IC generator options (incl. default values)
echo "$ "/usr/bin/time ${PHOSIM_IC_GENERATOR} -h
/usr/bin/time ${PHOSIM_IC_GENERATOR} -h

## Construct the generateIC command with static options (in config.sh) plus dynamic options passed by setupVisit.py
cmd='/usr/bin/time '${PHOSIM_IC_GENERATOR}
cmd="$cmd ${PHOSIM_IC_OPSSIM_DB}"
cmd="$cmd ${PHOSIM_IC_AGN_DB}"
cmd="$cmd ${PHOSIM_IC_DESCQA_CAT}"
cmd="$cmd ${PHOSIM_IC_FOV}"
cmd="$cmd ${PHOSIM_IC_RA}"
cmd="$cmd ${PHOSIM_IC_DEC}"
cmd="$cmd ${PHOSIM_IC_OPTS}"
cmd="$cmd ${PHOSIM_IC_MINMAG}"
cmd="$cmd ${PHOSIM_IC_WARNINGS}"
cmd="$cmd $options"

## Run the IC generator
echo
echo
echo
echo "================== Begin phosim instance catalog generator ============================="
date
echo "$ "$cmd
echo
eval $cmd
rc=$?
echo "================== End phosim instance catalog generator ============================="
echo rc=$rc
date
echo
echo
exit $rc

