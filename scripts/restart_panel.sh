#!/bin/bash

pkill -x panel.sh
pkill lemonbar

# launch panel
panel.sh &

