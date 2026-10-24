#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
"$SCRIPT_DIR/../sync-wofi-style.sh"

if pgrep -x wofi >/dev/null; then
    pkill -x wofi
else
    selection=$(cliphist list | sed 's/^[0-9]\t//' | wofi --dmenu || true)
    [[ -n "$selection" ]] || exit 0
    printf '%s\n' "$selection" | cliphist decode | wl-copy
fi
