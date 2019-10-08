#!/usr/bin/env bash

set -eu

pillow=(awesome compton kitty rofi themes
    systemd vim x xresources zsh
)

i3=(
    compton i3 polybar-base rofi-base
    themes systemd vim x zsh
)

dark=(
   dunst-dark polybar-dark rofi-dark xresources-dark 
)

light=(
   dunst-light polybar-light rofi-light xresources-light 
)

name=$1[@]
wow=("${!name}")

for dot in ${wow[@]}; do
    stow $dot --override=.+
    echo "Symlinking $dot"
done

if [[ "$1" == "dark" ]] || [[ "$1" == "light" ]]; then
    xrdb $HOME/.Xresources
    echo "Set Xresources"
fi

echo "Done!"
