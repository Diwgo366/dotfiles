#!/bin/bash
# ws-tracker.sh - Daemon that tracks pending launches and moves windows to the correct workspace
# Listens for openwindow events on socket2 and moves windows based on pending launches

PENDING_FILE="/tmp/hypr-ws-tracker-pending"

# Ensure pending file exists
touch "$PENDING_FILE"

handle() {
    case "$1" in
        openwindow*)
            # Parse: openwindow>>ADDRESS,WORKSPACEID,WORKSPACENAME,WINDOWCLASS,WINDOWTITLE
            IFS=, read -r ADDR WS_ID WS_NAME CLASS TITLE <<< "${1#openwindow>>}"
            
            # Trim whitespace
            CLASS=$(echo "$CLASS" | tr -d ' ' | tr -d '"')
            
            # Check if there's a pending launch for this class
            if [ -f "$PENDING_FILE" ]; then
                while IFS='|' read -r PENDING_CLASS PENDING_WS PENDING_TIME; do
                    if [ "$CLASS" = "$PENDING_CLASS" ]; then
                        # Check if the entry is not too old (max 10 seconds)
                        CURRENT_TIME=$(date +%s)
                        if [ $((CURRENT_TIME - PENDING_TIME)) -lt 10 ]; then
                            # Move the window to the target workspace
                            hyprctl dispatch movetoworkspace "$PENDING_WS,address:$ADDR" >/dev/null 2>&1
                            # Remove this pending entry
                            sed -i "/^${PENDING_CLASS}|/d" "$PENDING_FILE"
                        else
                            # Entry is too old, remove it
                            sed -i "/^${PENDING_CLASS}|/d" "$PENDING_FILE"
                        fi
                        break
                    fi
                done < "$PENDING_FILE"
            fi
            ;;
    esac
}

# Start listening to socket2 events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock 2>/dev/null | while read -r line; do
    handle "$line"
done
