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

scriptdir=$(dirname "$(readlink -f "$0")")

# Install stow if it doesn't exist
if [[ ! -x "$scriptdir/stow-build/bin/stow" ]]; then
    echo "Installing stow..."
    cd stow && rm -rf .git && git init && autoreconf -i 
    ./configure --prefix=$scriptdir/stow-build
    make install && make clean && rm -rf .git && cd ..
fi

name=$1[@]
wow=("${!name}")

for dot in ${wow[@]}; do
    stow-build/bin/stow $dot --override=.+
    echo "Symlinking $dot"
done

feh_change_bg() {
    if [[ -x "$(command -v feh)" ]]; then
        feh --bg-scale $1
        echo "Set background"
    else
        echo "feh not installed, can't change bg"
    fi
}

apply_xresources() {
    if [[ ! -d "$HOME/.vim/bg" ]]; then
        mkdir "$HOME/.vim/bg"
    fi

    xrdb $HOME/.Xresources
    echo "Applied Xresources"

    pgrep xst | xargs -L1 kill -USR1
    echo "Reloaded all xst terminals"

    if [[ -n $(pgrep dunst) ]]; then
        killall dunst
    else
        echo "Dunst process not found, won't restart"
    fi

    # Requires python module neovim-remote
    if [[ -x "$(command -v nvr)" ]] && [[ -n $(pgrep nvim) ]]; then
        nvr --remote-send ":set bg=$1<CR>"
        echo "Changed background of all nvim processes"
    else
        echo "Neovim-remote and/or nvim process not found, won't change bg"
    fi

    if [[ -n $(pgrep polybar) ]]; then
        polybar-msg cmd restart > /dev/null 2>&1
        echo "Reloaded polybar"
    else
        echo "Polybar not found, won't restart"
    fi

    i3-msg reload > /dev/null 2>&1
    echo "Reloaded i3"
}

apply_xresources $1

if [[ "$1" == "dark" ]]; then
    feh_change_bg $HOME/.config/i3/dark-flower.jpg
elif [[ "$1" == "light" ]]; then
    feh_change_bg $HOME/.config/i3/pink-mountain.jpg
fi

echo "Done!"
