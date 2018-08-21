#!/bin/bash
# finishVisit.sh - set up environment for this job step, then call main script

## General task configuration (for all steps)
source ${DC2_CONFIGDIR}/config.sh

## Env setup for DM-related activities

### Location of needed utilities

################# These two repos are **TEMPORARY** for task development
export DMX_SIM_UTILS=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/desc_sim_utils
export DMX_LSSTCAM=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/obs_lsstCam
################# These two repos are **TEMPORARY** for task development

source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/setup.sh
source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/weekly/loadLSST.bash
setup lsst_distrib
setup -r ${DMX_SIM_UTILS}
setup -r ${DMX_LSSTCAM} 


## Dump environment variables for posterity
echo "********************************************************************************"
echo
echo "Most Environment Variables:"
echo "-------------------------------------"
printenv | grep -v ^PE_ | grep -v ^CRAY | sort
echo
echo
date
echo "--------------------------------------------------------------------"
echo

## Final step: run task code
${DC2_CONFIGDIR}/finishVisit.py
exit $?
