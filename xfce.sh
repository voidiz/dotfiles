#!/usr/bin/env bash

set -e

dots=(compton-xfce dunst-xfce kitty rofi themes vim x xresources zsh)

for dot in ${dots[@]}; do
    stow $dot
    echo "Symlinking $dot"
done

echo "Done!"
