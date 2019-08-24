#!/usr/bin/env bash

set -eu

pillow=(awesome compton kitty rofi themes spacemacs vim x xresources zsh)
i3=(compton dunst i3 kitty polybar rofi themes spacemacs vim x xresources zsh)
xfce=(compton-xfce dunst-xfce kitty rofi themes spacemacs vim x xresources zsh)

name=$1[@]
wow=("${!name}")

for dot in ${wow[@]}; do
    stow $dot
    echo "Symlinking $dot"
done

echo "Done!"
