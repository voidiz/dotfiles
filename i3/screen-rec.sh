#!/bin/bash

set -eu

delay=1
duration=5
filepath="$HOME/$(date +%s).webm"

giph -s -d $delay -t $duration -y $filepath
dragon-drag-and-drop $filepath --and-exit
