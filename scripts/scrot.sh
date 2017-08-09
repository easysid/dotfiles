#!/bin/bash

if [ -n "$1" ];
    then k=${1}
    else k=3
fi
echo -n 'Taking shot in '
while [ $k -gt 0 ]
do echo -n "$k..."
k=$(($k - 1))
sleep 1
done
k=$(date +%y%m%d_%H%M%S)
# imlib2_grab ~/shot$k.png
import -window root ~/shot$k.png
# echo "Saved as $HOME/shot$k.png"


