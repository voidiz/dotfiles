#!/bin/bash

set -eu

delay=1
duration=15
filepath="$HOME/Videos/$(date +%s).mp4"

giph -s -d $delay -t $duration -y $filepath
dragon-drag-and-drop $filepath --and-exit
