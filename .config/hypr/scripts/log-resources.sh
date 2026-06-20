#!/bin/bash
LOG_DIR="$HOME/.local/share/resource-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d).log"

{
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="

  echo "--- CPU Load ---"
  uptime

  echo "--- Memory ---"
  free -h

  echo "--- Top 10 CPU % ---"
  ps -eo user,pid,%cpu,%mem,cputime,comm --sort=-%cpu | head -11

  echo "--- Top 10 MEM % ---"
  ps -eo user,pid,%cpu,%mem,cputime,comm --sort=-%mem | head -11

  echo "--- Swap ---"
  swapon --show 2>/dev/null || echo "no swap"
} >> "$LOG_FILE"
