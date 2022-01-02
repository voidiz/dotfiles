#!/usr/bin/env bash

tray_height=25
height=$(xdpyinfo | awk '/dimensions/{split($2,res,"x");print res[2]}')
pos=$(xdotool search --name --onlyvisible "Polybar tray window" \
    getwindowgeometry | grep $((height + tray_height)) )

if [[ -n "$pos" ]]; then
    xdotool search --name --onlyvisible "Polybar tray window" \
       windowmove --sync --relative 0 -60
else
    xdotool search --name --onlyvisible "Polybar tray window" \
       windowmove --sync --relative 0 60
fi
