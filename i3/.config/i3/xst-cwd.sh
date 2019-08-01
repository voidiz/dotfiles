#/usr/bin/env bash

# Credit:
# https://faq.i3wm.org/question/150/how-to-launch-a-terminal-from-here/

id=$(xdpyinfo | grep focus | cut -f4 -d " ")
pid=$(pgrep -P $(xprop -id $id | grep -m 1 PID | cut -d " " -f 3))

if [ -e "/proc/$pid/cwd" ]; then
    xst zsh -c "cd $(readlink /proc/$pid/cwd); zsh" &
else
    xst &
fi
