#!/usr/bin/env bash

set -e

dots=(awesome compton kitty rofi themes vim x xresources zsh)

for dot in ${dots[@]}; do
    stow $dot
    echo "Symlinking $dot"
done

echo "Done!"
