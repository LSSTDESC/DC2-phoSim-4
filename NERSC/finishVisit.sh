#!/bin/bash
# finishVisit.sh - Final clean-up steps for this visit

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

## First step: run pythonic part
${DC2_CONFIGDIR}/finishVisit.py
rc1=$?
if [ $rc1 -ne 0 ]; then 
    echo "%FAIL: finishVisit.py, rc = "$rc1
    date
    exit $rc1
fi

exit
