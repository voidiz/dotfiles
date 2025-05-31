#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_PATH/common.sh"

NIRI_DOTS=(
    rofi niri waybar
)

NIRI_PACKAGES="
gtklock niri rofi-wayland swaybg swayidle swaync waybar
xdg-desktop-portal-gnome wl-clipboard wlsunset xdg-desktop-portal-gtk
xwayland-satellite
"

install_packages "official" "$COMMON_PACKAGES"
install_packages "official" "$NIRI_PACKAGES"
install_packages "aur" "$COMMON_AUR_PACKAGES"
stow_dots COMMON_DOTS
stow_dots NIRI_DOTS
post_setup
