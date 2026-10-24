#!/usr/bin/env bash

set -u

RUNTIME_DIR="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
LOCKFILE="$RUNTIME_DIR/hypr-monitor-toggle.lock"
MODEFILE="$RUNTIME_DIR/hypr-monitor-mode"
THEME_FILE="/home/diego/Proyectos/ags/src/themes/theme.json"

exec 8>"$LOCKFILE"
flock -n 8 || exit 0

external_monitor=$(hyprctl monitors all -j | jq -r '[.[] | select(.name != "eDP-1")][0].name // empty')
if [[ -z "$external_monitor" ]]; then
    notify-send "Monitor" "No hay un monitor externo conectado"
    exit 1
fi

current_mode=$(cat "$MODEFILE" 2>/dev/null || printf 'extend')
if [[ "$current_mode" == "mirror" ]]; then
    next_mode=extend
    if ! hyprctl eval "hl.monitor({ output = \"$external_monitor\", mode = \"preferred\", position = \"auto-right\", scale = \"auto\", mirror = \"\" })"; then
        notify-send "Monitor" "No se pudo extender la pantalla"
        exit 1
    fi
    message="Extendido"
else
    next_mode=mirror
    if ! hyprctl eval "hl.monitor({ output = \"$external_monitor\", mode = \"preferred\", position = \"auto\", scale = \"auto\", mirror = \"eDP-1\" })"; then
        notify-send "Monitor" "No se pudo duplicar la pantalla"
        exit 1
    fi
    message="Duplicado"
fi

printf '%s\n' "$next_mode" > "$MODEFILE"

# Clean up any legacy mpvpaper PIDs from old wallpaper.sh
pkill -f "mpvpaper" 2>/dev/null || true
: > "$RUNTIME_DIR/hypr-mpvpaper.pid"

# Trigger daemon to reapply wallpaper with new monitor mode
touch "$THEME_FILE" 2>/dev/null || true

notify-send "Monitor" "$message"