#!/usr/bin/env bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
MONITOR_SCRIPT="$SCRIPT_DIR/mpvpaper-monitor.sh"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
LOCKFILE="$RUNTIME_DIR/hypr-wallpaper.lock"
PIDFILE="$RUNTIME_DIR/hypr-mpvpaper.pid"
MONITOR_PIDFILE="$RUNTIME_DIR/hypr-mpvpaper-monitor.pid"
MODEFILE="$RUNTIME_DIR/hypr-monitor-mode"
WALLPAPER="${1:-$HOME/.local/share/wallpapers/bg.mp4}"

terminate_pid() {
	local pid="$1"
	if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
		kill -CONT "$pid" 2>/dev/null || true
		kill "$pid" 2>/dev/null || true
		for _ in {1..20}; do
			kill -0 "$pid" 2>/dev/null || return 0
			sleep 0.05
		done
		kill -KILL "$pid" 2>/dev/null || true
	fi
}

if [[ ! -r "$WALLPAPER" ]]; then
	printf 'Wallpaper not found: %s\n' "$WALLPAPER" >&2
	exit 1
fi

# Detect if image or video
is_image=false
if [[ "$WALLPAPER" =~ \.(jpg|jpeg|png|webp|bmp|gif)$ ]]; then
	is_image=true
fi

exec 9>"$LOCKFILE"
flock -n 9 || exit 0

while read -r old_mpvpaper_pid; do
	terminate_pid "$old_mpvpaper_pid"
done < <(ps -eo pid=,comm=,args= | awk -v wallpaper="$WALLPAPER" \
	'$2 == "mpvpaper" && index($0, wallpaper) { print $1 }')

while read -r old_monitor_pid; do
	terminate_pid "$old_monitor_pid"
done < <(pgrep -f -- "$MONITOR_SCRIPT" || true)
if [[ -s "$PIDFILE" ]]; then
	while read -r old_mpvpaper_pid; do
		if [[ "$old_mpvpaper_pid" =~ ^[0-9]+$ ]] && [[ "$(ps -p "$old_mpvpaper_pid" -o comm= 2>/dev/null)" == "mpvpaper" ]]; then
			terminate_pid "$old_mpvpaper_pid"
		fi
	done < "$PIDFILE"
fi

mode=$(cat "$MODEFILE" 2>/dev/null || printf 'extend')
monitors=()
for _ in {1..20}; do
	mapfile -t monitors < <(hyprctl monitors -j | jq -r --arg mode "$mode" \
		'[.[] | select($mode != "mirror" or .name == "eDP-1") | .name] | .[]')
	((${#monitors[@]} > 0)) && break
	sleep 0.05
done

: > "$PIDFILE"
for monitor in "${monitors[@]}"; do
	if [[ "$is_image" == true ]]; then
		# Crop proportionally to fill the monitor instead of leaving black bars.
		nohup mpvpaper -o "loop=yes --panscan=1.0" "$monitor" "$WALLPAPER" > /dev/null 2>&1 9>&- &
	else
		# Videos: auto-pause to save resources
		nohup mpvpaper -p -o "loop-file=inf no-audio hwdec=auto" "$monitor" "$WALLPAPER" > /dev/null 2>&1 9>&- &
	fi
	printf '%s\n' "$!" >> "$PIDFILE"
done

if [[ ! -s "$PIDFILE" ]]; then
 	printf 'No active monitors available for wallpaper\n' >&2
 	exit 1
 fi

exec 9>&-
# Only run monitor script for videos (to pause when windows present)
if [[ "$is_image" == false ]]; then
	MPVPAPER_PIDFILE="$PIDFILE" nohup "$MONITOR_SCRIPT" > /dev/null 2>&1 &
	printf '%s\n' "$!" > "$MONITOR_PIDFILE"
else
	# For images, write empty monitor pid file
	: > "$MONITOR_PIDFILE"
fi
