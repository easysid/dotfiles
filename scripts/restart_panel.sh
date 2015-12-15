#!/bin/bash

pkill -x panel.sh
pkill bar
pkill conky

# launch panel
panel.sh &

