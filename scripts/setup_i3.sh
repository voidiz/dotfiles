#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_PATH/common.sh"

I3_DOTS=(
    dunst fusuma i3 picom polybar x xresources
)

I3_PACKAGES="
xorg-server xorg-xinit xorg-xrandr xorg-xdpyinfo xorg-xev

i3-gaps dunst flameshot picom polybar rofi

xclip xdotool xsel
"

I3_AUR_PACKAGES="
i3lock-color ruby-fusuma
"

apply_xresources() {
    # Apply xresources
    xrdb "$HOME/.Xresources"
    echo "Applied Xresources"

    # Reload dunst
    if [[ -n $(pgrep dunst) ]]; then
        killall dunst
        echo "Restarted dunst"
    fi

    if [[ -n $(pgrep polybar) ]]; then
        polybar-msg cmd restart > /dev/null 2>&1
        echo "Reloaded polybar"
    fi

    if [[ -n $(pgrep i3) ]]; then
        i3-msg reload > /dev/null 2>&1
        echo "Reloaded i3"
    fi
}

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$I3_PACKAGES"
install_packages "aur" "$COMMON_AUR_PACKAGES"
install_packages "aur" "$I3_AUR_PACKAGES"
stow_dots COMMON_DOTS
stow_dots I3_DOTS
apply_xresources
post_setup
