#!/usr/bin/env bash

SINK="@DEFAULT_AUDIO_SINK@"

case "${1:-}" in
    up)
        wpctl set-mute "$SINK" 0
        wpctl set-volume "$SINK" 5%+ --limit 1.0
        ;;
    down)
        wpctl set-mute "$SINK" 0
        wpctl set-volume "$SINK" 5%-
        ;;
    mute)
        wpctl set-mute "$SINK" toggle
        MUTED=$(wpctl get-volume "$SINK" | grep -q MUTED && echo true || echo false)
        dbus-send --session --type=signal /com/ags/Overlay com.ags.Overlay.Show \
            string:mute string:"$MUTED"
        exit 0
        ;;
    *)
        exit 2
        ;;
esac

VOL=$(wpctl get-volume "$SINK" | awk '{print int($2*100)}')
[[ "$VOL" =~ ^[0-9]+$ ]] || exit 1
dbus-send --session --type=signal /com/ags/Overlay com.ags.Overlay.Show \
    string:volume string:"$VOL"
