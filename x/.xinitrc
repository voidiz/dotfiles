#!/bin/sh

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

systemctl --user import-environment DISPLAY

# Repeat rate
xset r rate 175 50

# Input method
fcitx -d

# Gnome keyring
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

monitor1=DP-1
monitor2=HDMI-1

# Monitor gamma
xrandr --current --output "$monitor1" --gamma 0.71:0.71:0.71

# Monitor position
xrandr --output "$monitor1" --mode 1920x1080 --rate 144.00 --pos 0x0 --primary \
    --output "$monitor2" --mode 1920x1080 --rate 60.00 --pos 1920x0

# osu! resolution
xrandr --newmode "1600x900_144.00"  311.75  1600 1736 1904 2208  900 903 908 981 -hsync +vsync
xrandr --addmode "$monitor1" 1600x900_144.00

# Tablet settings
xsetwacom set "Wacom Intuos S Pen stylus" MapToOutput "$monitor1" # Map to full resolution
xsetwacom set "Wacom Intuos S Pen stylus" Area 0 0 6000 3375 # top left area

# Slight smoothing (CTL-480)
xsetwacom set "Wacom Intuos S Pen stylus" Suppress 2
xsetwacom set "Wacom Intuos S Pen stylus" RawSample 4

# Lowest smoothing (CTL-490)
# xsetwacom set "Wacom Intuos S 2 Pen stylus" Suppress 0
# xsetwacom set "Wacom Intuos S 2 Pen stylus" RawSample 1
# xsetwacom set "Wacom Intuos S 2 Pad pad" Suppress 0
# xsetwacom set "Wacom Intuos S 2 Pad pad" RawSample 1

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

exec i3
