#!/usr/bin/env bash

case "${1:-}" in
    up) step='+' ;;
    down) step='-' ;;
    *) exit 2 ;;
esac

brightnessctl set "5%$step" >/dev/null

MAX=$(brightnessctl m)
CUR=$(brightnessctl g)
BRIGHT=$(awk -v current="$CUR" -v maximum="$MAX" \
    'BEGIN { if (maximum > 0) printf "%.0f", current / maximum * 100 }')
[[ -n "$BRIGHT" ]] || exit 1
dbus-send --session --type=signal /com/ags/Overlay com.ags.Overlay.Show \
    string:brightness string:"$BRIGHT"
