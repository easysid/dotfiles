#! /bin/sh
#
# clone_termite.sh - script to open another terminal in the same working dir
# taken from i3 forums
# Tuesday, 12 December 2017 21:40 IST
#

bash_pid=$(xprop -id $(bspc query -N -n) _NET_WM_PID | awk '{print $3+5}')
if [ -e "/proc/$bash_pid/cwd" ]; then
    termite -d "$(readlink /proc/$bash_pid/cwd)" &
else
    termite &
fi
