#!/bin/bash

~/.config/hypr/scripts/sync-wofi-style.sh

if pgrep -x wofi >/dev/null; then
    pkill wofi
    exit 0
fi

TARGET_WS=$(hyprctl activeworkspace -j | jq -r '.id')
SNAPSHOT=$(hyprctl clients -j | jq -c '[.[].address]')

wofi --show drun

# Mover cualquier ventana nueva al workspace original
for i in $(seq 1 200); do
    sleep 0.01
    NEW=$(hyprctl clients -j | jq -r --argjson snap "$SNAPSHOT" '
        [.[] | select(.address as $a | ($snap | index($a)) | not) | select(.mapped == true)] | .[0].address // ""
    ')
    if [[ -n "$NEW" ]]; then
        hyprctl eval "hl.dsp.window.move({ workspace = $TARGET_WS, address = \"$NEW\", follow = false })"
        break
    fi
done
