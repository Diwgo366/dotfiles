#!/bin/bash
# ws-launch.sh - Launch an app and register it for workspace tracking
# Usage: ws-launch.sh <command> [args...]

PENDING_FILE="/tmp/hypr-ws-tracker-pending"

# Capture current workspace
TARGET_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Get the window class that the app will create
# For thunar, it's "Thunar". For kitty, it's "kitty". etc.
APP_NAME="$1"
case "$APP_NAME" in
    thunar|Thunar) WINDOW_CLASS="Thunar" ;;
    kitty|Kitty) WINDOW_CLASS="kitty" ;;
    firefox|Firefox) WINDOW_CLASS="firefox" ;;
    code|Code) WINDOW_CLASS="Code" ;;
    *) WINDOW_CLASS="$APP_NAME" ;;
esac

# Register pending launch
echo "${WINDOW_CLASS}|${TARGET_WS}|$(date +%s)" >> "$PENDING_FILE"

# Launch the app
exec "$@"
