#!/bin/bash

~/.config/hypr/scripts/sync-wofi-style.sh

if pgrep -x wofi >/dev/null; then
    pkill wofi
    exit 0
fi

TARGET_WS=$(hyprctl activeworkspace -j | jq -r '.id')
ADDRS_BEFORE=$(hyprctl clients -j | jq -r '.[].address' | sort)

wofi --show drun --width 600

for i in $(seq 1 60); do
  sleep 0.05
  NEW_ADDR=$(comm -13 <(echo "$ADDRS_BEFORE") <(hyprctl clients -j | jq -r '.[].address' | sort) | head -1)
  if [[ -n "$NEW_ADDR" ]]; then
    hyprctl dispatch "hl.dsp.window.move({workspace = $TARGET_WS, address = \"$NEW_ADDR\", follow = false})"
    break
  fi
done
