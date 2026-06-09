#!/usr/bin/env bash

was_paused=false

while true; do
    ws_id=$(hyprctl activeworkspace -j 2>/dev/null | grep -oP '"id": \K[0-9]+')
    count=$(hyprctl clients 2>/dev/null | grep -c "workspace: $ws_id")
    mpvpaper_pid=$(pidof mpvpaper 2>/dev/null)

    if [ "$count" -gt 0 ] && [ -n "$mpvpaper_pid" ]; then
        if [ "$was_paused" = false ]; then
            kill -STOP "$mpvpaper_pid" 2>/dev/null
            was_paused=true
        fi
    elif [ "$count" -eq 0 ] && [ -n "$mpvpaper_pid" ]; then
        if [ "$was_paused" = true ]; then
            kill -CONT "$mpvpaper_pid" 2>/dev/null
            was_paused=false
        fi
    fi

    sleep 1
done
