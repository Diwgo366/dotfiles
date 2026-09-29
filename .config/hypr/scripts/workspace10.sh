#!/usr/bin/env bash
hyprctl dispatch 'hl.dsp.focus({ workspace = 10 })'
if ! pgrep -x spotify > /dev/null 2>&1; then
    spotify &
fi
