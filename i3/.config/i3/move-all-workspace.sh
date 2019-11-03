#!/usr/bin/env bash

cur_ws=$(i3-msg -t get_workspaces | \
    jq -r '.[] | select(.focused==true).name')
echo $cur_ws

i3-msg "rename workspace ${cur_ws} to temp; \
    rename workspace $1 to ${cur_ws}; \
    rename workspace temp to $1"
