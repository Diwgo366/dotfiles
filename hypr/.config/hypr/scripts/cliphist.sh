#!/bin/bash

if pgrep -f "wofi --dmenu" >/dev/null; then
    pkill -f "wofi --dmenu"
else
    cliphist list | wofi --dmenu | cliphist decode | wl-copy
fi