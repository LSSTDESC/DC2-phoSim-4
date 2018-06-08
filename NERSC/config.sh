# config.sh - general set up for phoSim task
#             updated for Run1.2

## Prepare to run phoSim
echo
echo "Entering config.sh "
echo "------------------"
date
echo
## Git repository containing visit lists and instanceCatalog generator
export DC2_REPO='/global/common/software/lsst/cori-haswell-gcc/DC2_Repo/DC2_Repo'

## Select which to use for this task (u,g,r,i,z,y)
export DC2_FILTER_LIST="u g r i z y"
export DC2_FIELD_LIST="WFD uDDF"

## Visit lists (note: same visit lists for run 1.1 and 1.2)
export DC2_VISIT_DB=${DC2_REPO}/data/Run1.1/"protoDC2_visits_${DC2_FIELD}_${DC2_FILTER}-band.txt"
echo 'DC2_VISIT_DB = '$DC2_VISIT_DB

##
### Instance Catalog
##
## Re-vamped 2/15/2018 to use 'prod' installations of IC-generation packages
export PHOSIM_IC_GEN='DYNAMIC'
export PHOSIM_IC_GENERATOR='generateInstCat.py'

# Run 1.1p setup
#export PHOSIM_IC_SETUP='/global/common/software/lsst/cori-haswell-gcc/Run1.1p_setup.bash'

# Run 1.2p setup
export PHOSIM_IC_SETUP='/global/common/software/lsst/cori-haswell-gcc/Run1.2p_setup.bash'

## Dynamic Instance Catalogs...
#
### InstanceCatalog generator static options

## Original DB files in r/w GPFS
#export PHOSIM_IC_OPSSIM_DB=" --db /global/projecta/projectdirs/lsst/groups/SSim/DC2/minion_1016_desc_dithered_v4.db "
#export PHOSIM_IC_AGN_DB=" --agn_db_name /global/projecta/projectdirs/lsst/groups/SSim/DC2/agn_db_mbh_7.0_m_i_30.0.sqlite "
#export PHOSIM_IC_AGN_DB=" --agn_db_name /global/projecta/projectdirs/lsst/groups/SSim/DC2/agn_db_mbh_7.0_m_i_30.0_gcr_protodc2_v3.db "

## Staged copies for reliability and performance reasons
export PHOSIM_IC_OPSSIM_DB=" --db /global/cscratch1/sd/descpho/Pipeline-tasks/DBstaging/minion_1016_desc_dithered_v4.db "
export PHOSIM_IC_AGN_DB=" --agn_db_name /global/cscratch1/sd/descpho/Pipeline-tasks/DBstaging/agn_db_mbh_7.0_m_i_30.0.sqlite "
export PHOSIM_IC_AGN_DB=" --agn_db_name /global/cscratch1/sd/descpho/Pipeline-tasks/DBstaging/agn_db_mbh_7.0_m_i_30.0_gcr_protodc2_v3.db "

export PHOSIM_IC_DESCQA_CAT=" --descqa_catalog protoDC2 "
export PHOSIM_IC_FOV=" --fov 2.1 " 
export PHOSIM_IC_RA=" --protoDC2_ra 55.064 "
export PHOSIM_IC_DEC=" --protoDC2_dec -29.783 "
export PHOSIM_IC_OPTS=" --enable_sprinkler "
export PHOSIM_IC_MINMAG=" --min_mag 10.0 "
export PHOSIM_IC_WARNINGS=" --suppress_warnings "

## Exclude sensors that have fewer than this many 'sources' in view.
export DC2_MINSOURCE=100


## Static Instance Catalogs...
## 3/27/2017 - Mustafa's private scratch area for collecting instanceCatalogs
#export PHOSIM_CATALOGS="/global/cscratch1/sd/mustafa/DC2-phoSim-3"
## 11/13/2017 - Test DC2 area for instanceCatalogs
export PHOSIM_CATALOGS="/global/cscratch1/sd/descpho/Pipeline-tasks/DC2-phoSim-1/catalogs"

## physics overrides and other commands for phoSim
export PHOSIM_COMMANDS=${DC2_REPO}/workflows/phosimConfig/commands.txt

## Global and persistent scratch space to where phoSim 'work' directory will be staged
export PHOSIM_SCR_ROOT=/global/cscratch1/sd/descpho/Pipeline-tasks/${TASKNAME}

## Flag for cleaning up $SCRATCH after visit is complete (0=disable, 1=enable)
export PHOSIM_SCR_CLEANUP=0

## Enable or disable the E2ADC step (0=disable, 1=enable)
export PHOSIM_E2ADC=1

## Crutch for phosim.py which wants to call the condor submit script
export PATH=${PATH}\:${DC2_WORKFLOW}/bin

## For setting up phoSim and DMTCP outputs
export filePermissions="02775"     #   rwxrwxr-x

echo "------------------"
echo
echo


