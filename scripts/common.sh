#!/usr/bin/env bash

set -euo pipefail

COMMON_DOTS=(
    mpv nvim rofi systemd themes wezterm zathura zsh
)

COMMON_PACKAGES="
noto-fonts noto-fonts-cjk ttf-font-awesome ttf-jetbrains-mono ttf-hanazono

pipewire pipewire-alsa pipewire-pulse pavucontrol alsa-utils lib32-pipewire

bluez bluez-utils iwd systemd-resolvconf tailscale

tlp

bat curl eza ffmpeg gnome-keyring imagemagick jq lazygit man-db man-pages nnn
ripgrep rsync stow syncthing wget yt-dlp zsh

deluge discord telegram-desktop geary fcitx5 fcitx5-configtool feh kdeconnect
keepassxc mpv mpv-mpris nautilus nsxiv spotify-launcher streamlink zathura
zathura-pdf-mupdf
"

COMMON_AUR_PACKAGES="
otf-san-francisco-mono ttf-unifont nerd-fonts-noto-sans-mono

sp

anki-bin dragon-drop chatterino2-bin dropbox google-chrome mozc-ut
fcitx5-mozc-ut nautilus-open-any-terminal wezterm-git
"

install_packages() {
    repository="$1"
    packages="$2"

    if [[ "$repository" == "official" ]]; then
        sudo pacman -S $packages --noconfirm
    elif [[ "$repository" == "aur" ]]; then
        if [[ ! -x "$(command -v yay)" ]]; then
            git clone https://aur.archlinux.org/yay.git $HOME/yay
            cd $HOME/yay && makepkg -si --noconfirm
            rm -rf $HOME/yay
        fi

        yay -S $packages --noconfirm
    fi
}

stow_dots() {
    declare -n dots="$1"
    for dot in "${dots[@]}"; do
        stow "$dot" --override=.+ --no-folding
        echo "Symlinking $dot"
    done
}

post_setup() {
    echo "Done!"
}
