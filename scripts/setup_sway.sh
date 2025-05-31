#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_PATH/common.sh"

SWAY_DOTS=(
    rofi nvim sway kanshi waybar
)

SWAY_PACKAGES="
gtklock kanshi rofi-wayland sway swaybg swayidle swaync waybar wl-clipboard
wlsunset xdg-desktop-portal-gnome xdg-desktop-portal-gtk
"

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$SWAY_PACKAGES"
install_packages "aur" "$COMMON_AUR_PACKAGES"
stow_dots COMMON_DOTS
stow_dots SWAY_DOTS
post_setup
