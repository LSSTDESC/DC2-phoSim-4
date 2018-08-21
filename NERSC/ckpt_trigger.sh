#!/bin/bash
## ckpt_trigger.sh -- This script will trigger a checkpoint action for any job step run under the control of dmtcp at NERSC
##                              and must first be 'registered' with a Pilot job
##
##  T.Glanzman - 8/10/2018

## Is this a checkpointable job step?
if [[ ! -v PIPELINE_CHECKPOINTABLE ]]; then

### No, ordinary job...do nothing
###    (but someday... it would be nice to kill non-checkpoint jobs to
###     eliminate the reaper delay)

    exit 0
##########################################

else
### Yes, checkpointable job

### Establish environment to run DMTCP (NERSC-supplied)
    module load dmtcp${nerscbuild}

### Establish DMTCP work areas (this may not be needed at all...)

    export DMTCP_WORK=$CSCRATCH/checkpointData/${PIPELINE_TASKPATH}/${PIPELINE_STREAMPATH}
    export DMTCP_CHECKPOINT_DIR=${DMTCP_WORK}/checkpointDir
    export DMTCP_TMPDIR=${DMTCP_WORK}/tmpDir
    export DMTCP_COORD_LOG_FILENAME=${DMTCP_WORK}/checkpointDir/`date +%Y%m%d.%H%M%S`.coord.log
    export DMTCP_RESTART_DIR=${DMTCP_CHECKPOINT_DIR}

### Clean up from any previous checkpointing activities
    rm CHECKPOINTED CHECKPOINTING CHECKPOINT-FAILED


### Trigger a checkpoint and block until complete
    touch CHECKPOINTING
    dmtcp_command  --coord-port `cat port.txt` -bc
    rc1=$?
    dmtcp_command  --coord-port `cat port.txt` -q
    rc2=$?
    mv CHECKPOINTING CHECKPOINTED
    if [[ $rc1 != 0 or $rc2 != 0 ]];then
	mv CHECKPOINTED CHECKPOINT-FAILED
    fi

    exit 99

fi
