#!/bin/bash

pos=$(xdotool search --name --onlyvisible "Polybar tray window" \
    getwindowgeometry | grep "\-50")

if [ -n "$pos" ]
then
    xdotool search --name --onlyvisible "Polybar tray window" \
       windowmove --sync --relative 0 60
else
    xdotool search --name --onlyvisible "Polybar tray window" \
       windowmove --sync --relative 0 -60
fi
