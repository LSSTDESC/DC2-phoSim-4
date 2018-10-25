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


echo 'SETUP for phoSim amplifier FITS file repackager'
echo


################# These three repos are **TEMPORARY** for task development
################# These three repos are **TEMPORARY** for task development
export DMX_DESC_SIM_UTILS=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/desc_sim_utils
export DMX_OBS_LSSTCAM=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/obs_lsstCam
export DMX_IMSIM=/global/projecta/projectdirs/lsst/production/DC2/TGtemp/imSim
################# These three repos are **TEMPORARY** for task development
################# These three repos are **TEMPORARY** for task development


echo 'DMX_DESC_SIM_UTILS = '$DMX_DESC_SIM_UTILS
echo 'DMX_OBS_LSSTCAM = '$DMX_OBS_LSSTCAM
echo 'DMX_IMSIM = '$DMX_IMSIM

## Define input (phoSim amplifier FITS files) and output
export input=${DC2_ROOT}/output/${DC2_SEVENDIGSTREAM}
export output=${DC2_ROOT}/ready4ingest/${DC2_SEVENDIGSTREAM}
echo 'input = '$input
echo 'output= '$output

## Create directory to hold tweaked files
if [ ! -d $output ]; then
    echo "Creating directory for modified FITS files"
    mkdir -pv $output
fi



echo
echo 'Start shifter'
cmd0='/usr/bin/time -v shifter --image=lsstdesc/stack-sims:w_2018_35-sims_2_10_0-v2 -- '
echo $cmd0
eval $cmd0 <<EOF

echo "DC2_ROOT = "$DC2_ROOT
echo "DC2_SEVENDIGSTREAM = "$DC2_SEVENDIGSTREAM

echo
echo 'Setup stack'
source /opt/lsst/software/stack/loadLSST.bash

echo
echo 'loadLSST'
source /opt/lsst/software/stack/loadLSST.bash

echo
echo 'setup lsst_distrib'
setup lsst_distrib

echo
echo 'setup lsst_sims'
setup lsst_sims

echo
echo 'setup desc_sim_utils'
setup -r ${DMX_DESC_SIM_UTILS}

echo
echo 'setup obs_lsstcam'
setup -r ${DMX_OBS_LSSTCAM}

echo
echo 'setup imSim'
setup -r ${DMX_IMSIM}

echo "Run phosim_repackager.py"
date
phosim_repackager.py --verbose --out_dir $output $input

echo "Return from phosim_repackager.py = "$?

EOF


rc=$?
echo
echo "Return code from shifter = "$rc

## Compress all of the repackager output (obsolete as of 10/21/2018)
#cmd="gzip ${output}"
#date
#echo ${cmd}
#eval ${cmd}'/*'

#############################################################################

echo
echo "phosim_repackager complete"
date


log_separator


## Ingest (reformatted) phoSim image files for DM use

########### Just a dummy app for now...

## ingestDriver.py [YourIngestDirectoryWithMapperFile] @pathtoyourFileList.txt --cores 8 --mode link -c allowError=True register.ignore=True

#date

exit
