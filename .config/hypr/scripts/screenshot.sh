#!/bin/bash
LOCKFILE=/tmp/screenshot.lock

exec 200>"$LOCKFILE"
flock -n 200 || { notify-send "Screenshot" "Ya hay una captura en curso"; exit 1; }

# Faster animation for freeze overlay
hyprctl keyword animation 'layersIn, 1, 2.0, default, slide' &>/dev/null
hyprctl keyword animation 'layersOut, 1, 2.0, default, slide' &>/dev/null
hyprctl keyword animation 'fadeLayersIn, 1, 2.0, default' &>/dev/null
hyprctl keyword animation 'fadeLayersOut, 1, 2.0, default' &>/dev/null

hyprpicker -rz &
HPID=$!
sleep 0.2

REGION=$(slurp)

kill "$HPID" 2>/dev/null
hyprctl reload &>/dev/null
exec 200>&-
if [ -z "$REGION" ]; then
  exit 1
fi

if [ "$1" = "clipboard" ]; then
  grim -g "$REGION" - | wl-copy
else
  grim -g "$REGION" "$XDG_SCREENSHOTS_DIR/screenshot-$(date +%Y-%m-%d-%H:%M:%S).png" && wl-copy < "$XDG_SCREENSHOTS_DIR/screenshot-$(date +%Y-%m-%d-%H:%M:%S).png"
fi
