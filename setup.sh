#!/usr/bin/env bash

set -eu

common=(
    kitty rofi themes systemd mpv nvim vim
    xresources zsh x tmux fusuma dunst zathura
)

i3=(
    picom polybar i3
)

xfce=(
    tint2
)

packages="
xorg-server xorg-xinit xorg-xrandr xorg-xdpyinfo
xorg-xev i3-gaps picom dunst noto-fonts noto-fonts-cjk
rofi htop gnome-keyring

pipewire pipewire-alsa pipewire-pulse pavucontrol
alsa-utils lib32-pipewire

bluez bluez-utils iwd openresolv tailscale

bat curl eza ffmpeg go nodejs npm python imagemagick jq
man-db man-pages python-pynvim python-jedi ripgrep rsync
stow syncthing tmux wget youtube-dl xclip xdotool
xsel zsh

deluge discord telegram-desktop geary fcitx5
fcitx5-configtool feh flameshot kdeconnect keepassxc
mpv streamlink nsxiv ttf-jetbrains-mono ttf-hanazono
zathura zathura-pdf-mupdf

nautilus
"

aur="
i3lock-color polybar neovim-remote nnn-git xst-git lazygit
dragon-drop

otf-sfmono ttf-font-awesome ttf-material-design-icons
ttf-unifont nerd-fonts-noto-sans-mono mozc-ut
fcitx5-mozc-ut

chatterino2-appimage spotify sp google-chrome
dropbox mpv-mpris ffmpeg-compat-57 indicator-kdeconnect-git
anki-official-binary-bundle

nautilus-open-any-terminal
"

stow_dots() {
    for dot in ${common[@]}; do
        stow $dot --override=.+ --no-folding
        echo "Symlinking $dot"
    done

    for dot in ${list_contents[@]}; do
        stow $dot --override=.+ --no-folding
        echo "Symlinking $dot"
    done

    # Symlink ~/.zsh/.zshrc to .zshrc
    if [[ ! -f "$HOME/.zshrc" ]]; then
        ln -s $HOME/.zsh/.zshrc $HOME/.zshrc
    fi
}

apply_xresources() {
    # Apply xresources
    xrdb $HOME/.Xresources
    echo "Applied Xresources"

    # Reload xst if any are open
    local ps=$(pgrep xst)
    if [[ -n $ps ]]; then
        kill -USR1 $ps
        echo "Reloaded all xst terminals"
    fi

    # Reload dunst
    if [[ -n $(pgrep dunst) ]]; then
        killall dunst
        echo "Restarted dunst"
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
    fi

    if [[ -n $(pgrep i3) ]]; then
        i3-msg reload > /dev/null 2>&1
        echo "Reloaded i3"
    fi
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

        # mpv mpris
        mkdir -p $HOME/.config/mpv/scripts
        ln -s /usr/lib/mpv/mpris.so $HOME/.config/mpv/scripts/mpris.so
    fi
}

if [[ $1 != "packages" ]] && [[ $1 != "aur" ]]; then
    list_name=$1[@]
    list_contents=${!list_name}
    stow_dots

    if ! xset q &>/dev/null; then
        echo "Done!"
        exit
    fi

    apply_xresources $1
else
    str_name=$1
    str_content=${!str_name}
    install_packages "$str_name" "$str_content"
fi

echo "Done!"
