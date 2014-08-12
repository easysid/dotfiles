#!/bin/bash

pkill -x bspwm_panel.sh
pkill bar
pkill conky
pkill sxhkd

# launch panel
sxhkd &
bspwm_panel.sh &

