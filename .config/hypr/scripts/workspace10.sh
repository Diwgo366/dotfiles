#!/usr/bin/env bash
hyprctl dispatch workspace 10
if ! pgrep -x spotify > /dev/null 2>&1; then
    spotify &
fi
