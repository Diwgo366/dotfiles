#!/usr/bin/env bash
set -u

RUNTIME_DIR="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
LOCKFILE="$RUNTIME_DIR/hypr-screenshot.lock"
HPID=""

cleanup() {
  if [[ -n "$HPID" ]]; then
    kill "$HPID" 2>/dev/null || true
    wait "$HPID" 2>/dev/null || true
    hyprctl reload &>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

exec 200>"$LOCKFILE"
flock -n 200 || { notify-send "Screenshot" "Ya hay una captura en curso"; exit 1; }

hyprpicker -rzq &
HPID=$!
sleep 0.1
REGION=$(slurp)
sleep 0.2

if [ -z "$REGION" ]; then
  exit 1
fi

if [ "$1" = "clipboard" ]; then
  grim -g "$REGION" - | wl-copy 200>&-
else
  SCREENSHOTS_DIR="${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots}"
  mkdir -p "$SCREENSHOTS_DIR"
  FILE="$SCREENSHOTS_DIR/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
  grim -g "$REGION" "$FILE" && wl-copy 200>&- < "$FILE"
fi
