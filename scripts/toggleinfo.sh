#! /bin/bash

# Script to toggle status info in bar. Expand or contract.

# Make sure the following file exists in autostart.
FILE='/tmp/bartoggle'

[[ $(< $FILE) -eq 0 ]] && BOOL=1 || BOOL=0
echo -n $BOOL > $FILE

