#!/usr/bin/env bash
pkill hyprpaper 2>/dev/null
pkill mpvpaper 2>/dev/null
sleep 2
mpvpaper -f -o "loop-file=inf no-audio" eDP-1 ~/.local/share/wallpapers/bg.mp4 > /dev/null 2>&1
