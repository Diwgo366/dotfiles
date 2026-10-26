#!/bin/bash
: "${AGS_DIR:?AGS_DIR no está configurada; revisa config/paths.lua}"

active_address=$(hyprctl activewindow -j | jq -r '.address // empty')

if ags list | grep -q ags; then
  ags toggle bar
else
  GTK_THEME=Adwaita ags run "$AGS_DIR/src/app.ts" &
fi

if [[ -n "$active_address" ]]; then
  hyprctl dispatch "hl.dsp.focus({ window = \"address:$active_address\" })"
fi
