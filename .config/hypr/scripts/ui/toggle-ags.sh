#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"

active_address=$(hyprctl activewindow -j | jq -r '.address // empty')
pip_y=64
if hyprctl layers -j | jq -e 'to_entries[] | .value.levels["2"][]? | select(.namespace == "bar")' >/dev/null; then
  pip_y=10
fi

if ags list | grep -q ags; then
  ags toggle bar
else
  ags run "$AGS_DIR/src/app.ts" &
fi

pip_info=$(hyprctl clients -j | jq -r '.[] | select(.title == "Imagen en imagen" or .title == "Pantalla en pantalla") | [.address, .monitor] | @tsv' | head -1)
if [[ -n "$pip_info" ]]; then
  IFS=$'\t' read -r pip_address pip_monitor <<< "$pip_info"
  monitor_width=$(hyprctl monitors -j | jq -r --argjson index "$pip_monitor" '.[$index].width')
  pip_x=$((monitor_width - 330))
  hyprctl dispatch "hl.dsp.focus({ window = \"address:$pip_address\" })"
  hyprctl dispatch "hl.dsp.window.move({ x = $pip_x, y = $pip_y, relative = false })"
fi

if [[ -n "$active_address" ]]; then
  hyprctl dispatch "hl.dsp.focus({ window = \"address:$active_address\" })"
fi