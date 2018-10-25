#!/bin/bash

export BB="False"
BBNAME="Run20p"
BBVAR="DW_PERSISTENT_STRIPED_"$BBNAME

echo "BBNAME = "$BBNAME
echo "BBVAR    = "$BBVAR

export BBROOT=""
if [[ -v "$BBVAR" ]]; then
    BBROOT=${!BBVAR}
    if [[ -d "$BBROOT" ]]; then
	export BB="True"
	export BBNAME
	export BBVAR
	export BBROOT
    fi
fi

if [[ $BB == "True" ]];then
    echo "BurstBuffer directory exists!"
    echo "BBROOT = "$BBROOT
    ls -laF $BBROOT
    touch $BBROOT/foo
else
    echo "No BurstBuffer today.  Sorry!"
fi
