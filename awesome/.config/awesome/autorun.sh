#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# Compton
run compton -CGb

# Touchpad gestures
# run fusuma -d

# Keyboard layout
setxkbmap se
