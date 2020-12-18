#!/bin/env sh

killall polybar

sleep 2;

polybar -c $HOME/.config/polybar/config.ini bigbar &
