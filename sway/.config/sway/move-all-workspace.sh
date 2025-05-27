#!/usr/bin/env bash

cur_ws=$(swaymsg -t get_workspaces | \
    jq -r '.[] | select(.focused==true).name')

# Don't do anything if trying to swap with the current workspace
if [[ "$cur_ws" = "$1" ]]; then
    exit 0
fi

swaymsg "rename workspace $cur_ws to temp; \
    workspace $1; \
    rename workspace $1 to $cur_ws; \
    rename workspace temp to $1; \
    workspace $1"
