## phosimSetup.sh - establish cori environment to run phoSim (and DMTCP)

## Select phoSim version
#version=v3.7.1   # Nov 2017
#version=v3.7.6   # 6 Dec 2017
#version=v3.7.7   # 22 Jan 2018
#version=v3.7.8   # 23 Jan 2018
#version=v3.7.9   # 30 Mar 2018
#version=v3.7.15  # 19 Jun 2018
#version=v3.7.16   # 27 Aug 2018
version=v3.7.16fat   # 15 Oct 2018 (local mod: increase array sizes for large catalogs)

## Select compiler used to build phoSim
#compiler=gcc
compiler=intel

## Determine if running on knl, or haswell node, and whether batch or
## interactive
partition=haswell
mode=batch
host=`hostname`

if [[ -n "$SLURM_JOB_PARTITION" ]]; then
    foo=`grep -c -i phi /proc/cpuinfo`
    if [[ $foo > 0 ]]; then
	partition=knl
	fi
else
    mode=interactive
fi

echo "Running on Cori-"$partition", host "$host


## Code pointers

### Check of BurstBuffer is available and primed
if [[ -d "$BBROOT" ]]; then
    export PHOSIM_ROOT=$BBDIR/software/phosim/${version}
else
    arch=cori-${partition}-${compiler}
    export PHOSIM_ROOT=/global/common/software/lsst/${arch}/phosim/${version}
fi



## dmtcp checkpointing (use 'module load dmtcp' rather than homebrew)
#export DMTCP_ROOT=/global/common/cori/contrib/lsst/dmtcp/2.4.5
#export PATH=$DMTCP_ROOT/bin:$PATH
#export MANPATH=$DMTCP_ROOT/share/man:$MANPATH



## Add dummy condor_submit_dag
export PATH=${DC2_ROOT}/bin:$PATH

## Module shenanigans on cori to run phoSim and DMTCP (checkpointing)
## By default, logging into Haswell or KNL will set up "Intel"
## development and runtime environments.

if [ $compiler == 'gcc' ]; then
    module swap PrgEnv-intel PrgEnv-gnu
    module swap gcc gcc/5.2.0
    module rm craype-network-aries
    module rm cray-libsci
    module unload craype
    export CC=gcc
fi

## Note that phoSim requires python v2 rather than v3
module load python/2.7-anaconda

