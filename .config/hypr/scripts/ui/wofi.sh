#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
"$SCRIPT_DIR/../sync-wofi-style.sh"

if pgrep -x wofi >/dev/null; then
    pkill wofi
    exit 0
fi

TARGET_WS=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty' 2>/dev/null || true)
ADDRS_BEFORE=$(hyprctl clients -j 2>/dev/null | jq -r '.[].address' 2>/dev/null | sort || true)

wofi --show drun --width 600

[[ -n "$TARGET_WS" ]] || exit 0

for i in $(seq 1 60); do
  sleep 0.05
  NEW_ADDR=$(comm -13 <(echo "$ADDRS_BEFORE") <(hyprctl clients -j | jq -r '.[].address' | sort) | head -1)
  if [[ -n "$NEW_ADDR" ]]; then
    hyprctl dispatch "hl.dsp.window.move({workspace = $TARGET_WS, address = \"$NEW_ADDR\", follow = false})"
    break
  fi
done
