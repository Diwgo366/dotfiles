#!/usr/bin/env bash

set -u

PIDFILE="${MPVPAPER_PIDFILE:-${XDG_RUNTIME_DIR:-/tmp}/hypr-mpvpaper.pid}"
mpvpaper_pids=()
declare -A paused_pids=()

cleanup() {
    for mpvpaper_pid in "${!paused_pids[@]}"; do
        if [[ "${paused_pids[$mpvpaper_pid]}" == true ]]; then
            kill -CONT "$mpvpaper_pid" 2>/dev/null || true
        fi
    done
}
trap cleanup EXIT
trap 'exit 0' INT TERM

while true; do
    ws_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')
    mapfile -t mpvpaper_pids < "$PIDFILE" 2>/dev/null || mpvpaper_pids=()

    if [[ ! "$ws_id" =~ ^[0-9]+$ ]]; then
        sleep 1
        continue
    fi

    if ((${#mpvpaper_pids[@]} == 0)); then
        exit 0
    fi

    for mpvpaper_pid in "${mpvpaper_pids[@]}"; do
        if [[ ! "$mpvpaper_pid" =~ ^[0-9]+$ ]] || ! kill -0 "$mpvpaper_pid" 2>/dev/null; then
            exit 0
        fi
    done

    clients=$(hyprctl clients -j 2>/dev/null)
    monitors=$(hyprctl monitors -j 2>/dev/null)

    for mpvpaper_pid in "${mpvpaper_pids[@]}"; do
        monitor=$(ps -p "$mpvpaper_pid" -o args= 2>/dev/null | awk '{print $(NF-1)}')
        monitor_ws=$(jq -r --arg monitor "$monitor" \
            '.[] | select(.name == $monitor) | .activeWorkspace.id // empty' <<< "$monitors")
        monitor_id=$(jq -r --arg monitor "$monitor" \
            '.[] | select(.name == $monitor) | .id // empty' <<< "$monitors")

        if [[ ! "$monitor_ws" =~ ^[0-9]+$ ]] || [[ ! "$monitor_id" =~ ^[0-9]+$ ]]; then
            continue
        fi

        count=$(jq --argjson monitor "$monitor_id" --argjson ws "$monitor_ws" \
            '[.[] | select(.monitor == $monitor and .workspace.id == $ws and .mapped and (.hidden | not))] | length' \
            <<< "$clients")

        if [[ "$count" -gt 0 ]]; then
            if [[ "${paused_pids[$mpvpaper_pid]:-false}" == false ]]; then
                kill -STOP "$mpvpaper_pid"
                paused_pids[$mpvpaper_pid]=true
            fi
        elif [[ "$count" -eq 0 ]]; then
            if [[ "${paused_pids[$mpvpaper_pid]:-false}" == true ]]; then
                kill -CONT "$mpvpaper_pid"
                paused_pids[$mpvpaper_pid]=false
            fi
        fi
    done

    sleep 1
done
