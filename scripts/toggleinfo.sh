#! /bin/sh

# Script to toggle status info in bar. Expand or contract.

# Make sure the following file exists in autostart.
# FILE='/tmp/bartoggle'
FILE='/tmp/bar_sysinfo_toggle'

[ "$(cat $FILE)" -eq 0 ] && echo -n 1 > $FILE || echo -n 0 > $FILE

