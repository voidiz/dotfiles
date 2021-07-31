#!/bin/bash

set -eu

# Create a screenshot of the screen
import -window root /tmp/lockframe.jpg

# Pixelate it
convert -scale 10% -scale 1000% /tmp/lockframe.jpg /tmp/lockframe.jpg

primary="$(xrdb -query | grep i3wm\.bg: | grep -oE "#.{6}")FF"
secondary="$(xrdb -query | grep i3wm\.bg2: | grep -oE "#.{6}")FF"
boxbg="#00000000"
wrong="#FF0000FF"

i3lock -k -i /tmp/lockframe.jpg \
    --insidever-color=$boxbg --insidewrong-color=$boxbg \
    --inside-color=$boxbg --ringver-color=$primary \
    --ringwrong-color=$wrong --ring-color=$secondary \
    --line-color=$boxbg --keyhl-color=$primary \
    --bshl-color=$primary --separator-color=$primary \
    --verif-color=$primary --wrong-color=$wrong \
    --layout-color=$primary --ind-pos="200:800" \
    --time-color=$secondary --time-pos="250:780" \
    --date-color=$secondary --date-pos="250:810" \
    --radius=25 --ring-width=10 \
    --verif-text="" --wrong-text="" --noinput-text="" \
    --lock-text="" --lockfailed-text="" \
    --date-size=14 \
    --time-align=1 --date-align=1 --indicator
