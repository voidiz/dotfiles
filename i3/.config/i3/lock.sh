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
    --insidevercolor=$boxbg --insidewrongcolor=$boxbg \
    --insidecolor=$boxbg --ringvercolor=$primary \
    --ringwrongcolor=$wrong --ringcolor=$secondary \
    --linecolor=$boxbg --keyhlcolor=$primary \
    --bshlcolor=$primary --separatorcolor=$primary \
    --verifcolor=$primary --wrongcolor=$wrong \
    --layoutcolor=$primary --indpos="200:800" \
    --timecolor=$secondary --timepos="250:780" \
    --datecolor=$secondary --datepos="250:810" \
    --radius=25 --ring-width=10 \
    --veriftext="" --wrongtext="" --noinputtext="" \
    --locktext="" --lockfailedtext="" \
    --datesize=14 \
    --time-align=1 --date-align=1 --indicator
