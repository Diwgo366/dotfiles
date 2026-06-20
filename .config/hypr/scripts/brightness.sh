#!/bin/bash

case "${1}" in
    up)   brightnessctl set 5%+ ;;
    down) brightnessctl set 5%- ;;
esac

MAX=$(brightnessctl m)
CUR=$(brightnessctl g)
BRIGHT=$(awk "BEGIN {printf \"%.0f\", $CUR / $MAX * 100}")
dbus-send --session --type=signal /com/ags/Overlay com.ags.Overlay.Show \
    string:brightness string:"$BRIGHT"
