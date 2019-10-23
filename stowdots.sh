#!/usr/bin/env bash

set -eu

pillow=(awesome compton kitty rofi themes
    systemd vim-base x xresources zsh
)

i3=(
    compton i3 polybar-base rofi-base
    themes systemd vim-base x zsh
)

dark=(
   dunst-dark polybar-dark rofi-dark xresources-dark 
   vim-dark
)

light=(
   dunst-light polybar-light rofi-light xresources-light 
   vim-light
)

name=$1[@]
wow=("${!name}")

for dot in ${wow[@]}; do
    stow $dot --override=.+
    echo "Symlinking $dot"
done

apply_xresoures() {
    if [[ ! -d "$HOME/.vim/bg" ]]; then
        mkdir "$HOME/.vim/bg"
    fi

    xrdb $HOME/.Xresources
    echo "Applied Xresources"

    pgrep xst | xargs -L1 kill -USR1
    echo "Reloaded all xst terminals"

    if [[ -n $(pgrep dunst) ]]; then
        killall dunst
    fi

    # Requires python module neovim-remote
    if [[ -x "$(command -v nvr)" ]] && [[ -n $(pgrep nvim) ]]; then
        nvr --remote-send ":set bg=$1<CR>"
        echo "Changed background of all nvim processes"
    fi

    if [[ -n $(pgrep polybar) ]]; then
        polybar-msg cmd restart > /dev/null 2>&1
        echo "Reloaded polybar"
    fi

    i3-msg reload > /dev/null 2>&1
    echo "Reloaded i3"
}

if [[ "$1" == "dark" ]]; then
    apply_xresoures $1

    if [[ -x "$(command -v hsetroot)" ]]; then
        feh --bg-scale $HOME/.config/i3/dark-pink-mountain.jpg
        echo "Set background"
    fi
elif [[ "$1" == "light" ]]; then
    apply_xresoures $1

    if [[ -x "$(command -v feh)" ]]; then
        feh --bg-scale $HOME/.config/i3/pink-mountain.jpg
        echo "Set background"
    fi
fi

echo "Done!"
