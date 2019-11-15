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

packages="
    xorg-server xorg-xinit i3-gaps compton dunst i3lock-color
    noto-fonts rofi

    pulseaudio pulseaudio-alsa pulseaudio-bluetooth pavucontrol

    bluez bluez-utils netctl ifplugd wpa_supplicant

    curl ffmpeg go nodejs npm python imagemagick neovim 
    python-pynvim stow wget youtube-dl zsh

    deluge firefox discord telegram-desktop fcitx
    fcitx-mozc fcitx-im feh flameshot kdeconnect keepassxc
    mpv mps-youtube streamlink sxiv ttf-hanazono zathura
    zathura-pdf-mupdf
"

aur="
    polybar neovim-remote nnn-git xst-git 

    otf-san-francisco otf-sfmono ttf-font-awesome 
    ttf-material-design-icons ttf-unifont

    chatterino2-git plex-media-player spicetify-cli spotify
    ffmpeg-compat-57 dropbox indicator-kdeconnect-git
"

stow_dots() {
    for dot in ${list_contents[@]}; do
        stow $dot --override=.+ --no-folding
        echo "Symlinking $dot"
    done
}

feh_change_bg() {
    feh --bg-scale $1
    echo "Set background"
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
        nvr --nostart --remote-send ":set bg=$1<CR>"
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

install_packages() {
    if [[ $1 == "packages" ]]; then
        pacman -S $2 --noconfirm
    elif [[ $1 == "aur" ]]; then
        if [[ ! -x "$(command -v yay)" ]]; then
            git clone https://aur.archlinux.org/yay.git $HOME/yay
            cd $HOME/yay && makepkg -si --noconfirm
            rm -rf $HOME/yay
        fi
        yay -S $2 --noconfirm
    fi
}

if [[ $1 != "packages" ]] && [[ $1 != "aur" ]]; then
    list_name=$1[@]
    list_contents=${!list_name}
    stow_dots "$list_contents"

    if ! xset q &>/dev/null; then
        echo "Done!"
        exit
    fi

    apply_xresources $1

    if [[ $1 == "dark" ]]; then
        feh_change_bg $HOME/.config/i3/dark-flower.jpg
    elif [[ $1 == "light" ]]; then
        feh_change_bg $HOME/.config/i3/pink-mountain.jpg
    fi
else
    str_name=$1
    str_content=${!str_name}
    install_packages "$str_name" "$str_content"
fi

echo "Done!"
