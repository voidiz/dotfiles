#!/usr/bin/env bash

set -euo pipefail

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./common.sh
source "$script_path/common.sh"

sway_dots=(
    rofi nvim sway kanshi waybar
)

sway_packages="
gtklock kanshi rofi-wayland sway swaybg swayidle swaync waybar wl-clipboard
wlsunset xdg-desktop-portal-gnome xdg-desktop-portal-gtk
"

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$sway_packages"
install_packages "aur" "$COMMON_AUR_PACKAGES"
stow_dots COMMON_DOTS
stow_dots sway_dots
post_setup
