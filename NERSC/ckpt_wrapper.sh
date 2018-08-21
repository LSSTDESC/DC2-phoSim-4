#!/bin/bash
## ckpt_wrapper.sh - This script handles the launching of checkpointable jobs using dmtcp at NERSC
##                               and must first be 'registered' with the Pilot
## T.Glanzman - 8/10/2018

## Store command line args ( = pipeline_wrapper +user command)
pcmd=$@
echo "args = "$pcmd
exit


## Is this a checkpointable job step?
if [[ ! -v PIPELINE_CHECKPOINTABLE ]]; then

### No, ordinary job
# launch pipeline job and wait for completion
    eval $pcmd
    rc=$?
    exit $rc

##########################################

else
### Yes, checkpointable job

### Establish environment to run DMTCP (NERSC-supplied)
    module load dmtcp${nerscbuild}

### Establish DMTCP work areas

    export DMTCP_WORK=$CSCRATCH/checkpointData/${PIPELINE_TASKPATH}/${PIPELINE_STREAMPATH}
    export DMTCP_CHECKPOINT_DIR=${DMTCP_WORK}/checkpointDir
    export DMTCP_TMPDIR=${DMTCP_WORK}/tmpDir
    export DMTCP_COORD_LOG_FILENAME=${DMTCP_WORK}/checkpointDir/`date +%Y%m%d.%H%M%S`.coord.log
    export DMTCP_RESTART_DIR=${DMTCP_CHECKPOINT_DIR}

##export DMTCP_CHECKPOINT_INTERVAL=300

### Is this a fresh start or a restart of a checkpointed job step?
 
    if [[ -f CHECKPOINTED ]];then
#### Checkpointed job step
	mv CHECKPOINTED RUNNING
## Start DMTCP coordinator
	dmtcp_coordinator --coord-port 0 --port-file port.txt --exit-after-ckpt --daemon

## Run the checkpoint 'restart' script (and wait...)
	${DMTCP_CHECKPOINT_DIR}/dmtcp_restart_script.sh --coord-port `cat port.txt` 
	rc=$?

    else
#### Fresh job startup
	touch RUNNING

## Launch user code with dmtcp (and wait...)
	dmtcp_launch --new-coordinator --port-file port.txt $pcmd
	rc=$$?

    fi





## User code has terminated...why?

##   Note: the return code from this wrapper is unrelated to the
##   return code of the user's job (which is stored in the
##   pipeline_summary file).  In fact, the only return code noticed by
##   the Pilot is "99", the distinctive return code that means
##   "successful checkpoint"

    rm RUNNING

    if [[ $rc != 0 ]]; then
	    ## pipeline wrapper script failed, ugh!
	exit $rc

    elif [[ -f CHECKPOINTED ]]; then
	    ## successful checkpoint
	exit 99

    elif [[ -f CHECKPOINTING or -f CHECKPOINT-FAILED ]]; then 
	    ## unsuccessful checkpoint
	exit 100
    else
	    ## what else is there???
	exit 101
    fi
	    
fi
