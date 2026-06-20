#!/bin/bash

~/.config/hypr/scripts/sync-wofi-style.sh

if pgrep -f "wofi --dmenu" >/dev/null; then
    pkill -f "wofi --dmenu"
else
    cliphist list | sed 's/^[0-9]\t//' | cut -c 1-43| wofi --dmenu | cliphist decode | wl-copy
fi
