#!/bin/bash
LOCKFILE=/tmp/screenshot.lock

exec 200>"$LOCKFILE"
flock -n 200 || { notify-send "Screenshot" "Ya hay una captura en curso"; exit 1; }

hyprpicker -rzq &
HPID=$!
sleep 0.1
REGION=$(slurp)
sleep 0.2

kill "$HPID" 2>/dev/null
sleep 0.1
hyprctl reload &>/dev/null
exec 200>&-
if [ -z "$REGION" ]; then
  exit 1
fi

if [ "$1" = "clipboard" ]; then
  grim -g "$REGION" - | wl-copy
else
  FILE="$XDG_SCREENSHOTS_DIR/screenshot-$(date +%Y-%m-%d-%H:%M:%S).png"
  grim -g "$REGION" "$FILE" && wl-copy < "$FILE"
fi
