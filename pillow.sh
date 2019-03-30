#!/usr/bin/env bash

set -e

dots=(awesome compton kitty-pillow rofi-pillow themes vim x xresources-pillow zsh)

for dot in ${dots[@]}; do
    stow $dot
    echo "Symlinking $dot"
done

echo "Done!"
