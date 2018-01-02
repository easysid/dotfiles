#! /bin/sh
#
# clone_termite.sh - script to open another terminal in the same working dir
# taken from i3 forums
# Tuesday, 12 December 2017 21:40 IST
#

DIR=$HOME
win_id="$(bspc query -N -n)"
bash_pid=$(xprop -id $win_id _NET_WM_PID | awk '{print $3+5}')
if [ -e "/proc/$bash_pid/cwd" ]; then
    DIR="$(readlink /proc/$bash_pid/cwd)"
fi
termite -d "$DIR" &
