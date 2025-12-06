#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./common.sh
. "$script_dir/common.sh"

i3_dots=(
    dunst fusuma i3 picom polybar x xresources
)

i3_packages="
xorg-server xorg-xinit xorg-xrandr xorg-xdpyinfo xorg-xev

i3-gaps dunst flameshot picom polybar rofi

xclip xdotool xsel
"

i3_aur_packages="
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
        polybar-msg cmd restart >/dev/null 2>&1
        echo "Reloaded polybar"
    fi

    if [[ -n $(pgrep i3) ]]; then
        i3-msg reload >/dev/null 2>&1
        echo "Reloaded i3"
    fi
}

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$i3_packages"
install_packages "aur" "$COMMON_AUR_PACKAGES"
install_packages "aur" "$i3_aur_packages"
stow_dots COMMON_DOTS
stow_dots i3_dots
apply_xresources
post_setup
