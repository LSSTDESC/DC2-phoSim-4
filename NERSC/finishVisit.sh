#!/bin/bash
# finishVisit.sh - Final clean-up steps for this visit

## General task configuration (for all steps)
source ${DC2_CONFIGDIR}/config.sh

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

## Perform final steps for this visit
${DC2_CONFIGDIR}/finishVisit.py
rc1=$?
if [ $rc1 -ne 0 ]; then 
    echo "%FAIL: finishVisit.py, rc = "$rc1
    date
    exit $rc1
fi

exit
