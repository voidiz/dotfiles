#!/bin/bash

set -eu

delay=1
duration=20
filepath="$HOME/Videos/$(date +%s).mp4"

giph -s -d $delay -t $duration -y $filepath
dragon-drop $filepath --and-exit
