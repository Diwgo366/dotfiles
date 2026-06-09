#!/usr/bin/env bash
pkill mpvpaper 2>/dev/null
pkill -f mpvpaper-monitor 2>/dev/null
sleep 1
mpvpaper -f -o "loop-file=inf no-audio hwdec=auto" eDP-1 ~/.local/share/wallpapers/bg.mp4 > /dev/null 2>&1 &
sleep 1
nohup ~/.config/hypr/scripts/mpvpaper-monitor.sh > /dev/null 2>&1 &
