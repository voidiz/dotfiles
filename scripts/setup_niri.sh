#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./common.sh
source "$script_dir/common.sh"

niri_dots=(
    rofi niri waybar
)

niri_packages="
gtklock niri rofi-wayland swaybg swayidle swaync waybar
xdg-desktop-portal-gnome wl-clipboard wlsunset xdg-desktop-portal-gtk
xwayland-satellite
"

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$niri_packages"
install_packages "aur" "$COMMON_AUR_PACKAGES"
stow_dots COMMON_DOTS
stow_dots niri_dots
post_setup
