#!/bin/bash
# postProduction.sh - Final phosim file tweaking for future DM consumption

## General task configuration (for all steps)
source ${DC2_CONFIGDIR}/config.sh

## Env setup for DM-related activities

### Location of needed utilities

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


#############################################################################

## Reformat phoSim generated FITS image files

################# These two repos are **TEMPORARY** for task development
export DMX_SIM_UTILS=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/desc_sim_utils
export DMX_LSSTCAM=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/obs_lsstCam
################# These two repos are **TEMPORARY** for task development
echo 'DMX_SIM_UTILS='$DMX_SIM_UTILS
echo 'DMX_LSSTCAM='$DMX_LSSTCAM

echo 'Setup stack'
source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/setup.sh
echo 'loadLSST'
source /global/common/software/lsst/cori-haswell-gcc/stack/lsstsw/weekly/loadLSST.bash
echo 'setup lsst_distrib'
setup lsst_distrib
echo 'setup sim_utils'
setup -r ${DMX_SIM_UTILS}
echo 'setup lsstcam'
setup -r ${DMX_LSSTCAM} 

log_separator

## Define input (phoSim amplifier FITS files) and output
input=${DC2_ROOT}/output/${DC2_SIXDIGSTREAM}
output=${DC2_ROOT}/ready4ingest/${DC2_SIXDIGSTREAM}

echo 'input = '$input
echo 'output= '$output


## Create directory to hold tweaked files
if [ ! -d $output ]; then
    echo "Creating directory for modified FITS files"
    mkdir -pv $output
fi

cmd="phosim_repackager.py --verbose --out_dir $output $input"
date
echo $cmd
eval $cmd

rc1=$?
if [ $rc1 -ne 0 ]; then 
    echo "%FAIL: FITS header tweak, rc = "$rc1
    date
    exit 1
fi

## Compress all of the repackager output
cmd="gzip ${output}"
date
echo ${cmd}
eval ${cmd}'/*'

#############################################################################

log_separator


## Ingest (reformatted) phoSim image files for DM use

########### Just a dummy app for now...

## ingestDriver.py [YourIngestDirectoryWithMapperFile] @pathtoyourFileList.txt --cores 8 --mode link -c allowError=True register.ignore=True

date

exit
