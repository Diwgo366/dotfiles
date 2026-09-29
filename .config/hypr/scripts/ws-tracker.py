#!/usr/bin/env python3
"""
ws-tracker.py - Daemon that tracks pending launches and moves windows to the correct workspace.
Listens for openwindow events on Hyprland socket2 and moves windows based on pending launches.
"""

import os
import socket
import sys
import time
import json
import subprocess

PENDING_FILE = "/tmp/hypr-ws-tracker-pending"
MAX_AGE = 10  # seconds

def get_socket_path():
    runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not his:
        # Try to get it from hyprctl
        try:
            result = subprocess.run(["hyprctl", "instances", "-j"], capture_output=True, text=True)
            instances = json.loads(result.stdout)
            if instances:
                his = list(instances.keys())[0]
        except:
            pass
    if not his:
        print("ERROR: Cannot determine Hyprland instance signature", file=sys.stderr)
        sys.exit(1)
    return os.path.join(runtime, "hypr", his, ".socket2.sock")

def read_pending():
    """Read pending launches from file."""
    pending = []
    if os.path.exists(PENDING_FILE):
        try:
            with open(PENDING_FILE, "r") as f:
                for line in f:
                    line = line.strip()
                    if "|" in line:
                        parts = line.split("|")
                        if len(parts) == 3:
                            pending.append({
                                "class": parts[0],
                                "workspace": parts[1],
                                "time": int(parts[2])
                            })
        except:
            pass
    return pending

def write_pending(pending):
    """Write pending launches to file."""
    try:
        with open(PENDING_FILE, "w") as f:
            for item in pending:
                f.write(f"{item['class']}|{item['workspace']}|{item['time']}\n")
    except:
        pass

def move_window(addr, workspace):
    """Move a window to a workspace."""
    try:
        subprocess.run(
            ["hyprctl", "dispatch", "movetoworkspace", f"{workspace},address:{addr}"],
            capture_output=True, timeout=5
        )
    except:
        pass

def handle_event(line, pending):
    """Handle a socket2 event."""
    if not line.startswith("openwindow>>"):
        return pending

    # Parse: openwindow>>ADDRESS,WORKSPACEID,WORKSPACENAME,WINDOWCLASS,WINDOWTITLE
    data = line[len("openwindow>>"):]
    parts = data.split(",", 4)
    if len(parts) < 5:
        return pending

    addr = parts[0]
    window_class = parts[3].strip().strip('"')

    current_time = int(time.time())
    new_pending = []

    for item in pending:
        if item["class"].lower() == window_class.lower():
            age = current_time - item["time"]
            if age < MAX_AGE:
                move_window(addr, item["workspace"])
            # Don't keep this entry regardless
        else:
            new_pending.append(item)

    return new_pending

def main():
    sock_path = get_socket_path()
    print(f"ws-tracker: Connecting to {sock_path}", file=sys.stderr)

    # Ensure pending file exists
    open(PENDING_FILE, "a").close()

    while True:
        try:
            sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            sock.connect(sock_path)
            print("ws-tracker: Connected to Hyprland socket2", file=sys.stderr)

            buffer = b""
            while True:
                data = sock.recv(4096)
                if not data:
                    break

                buffer += data
                while b"\n" in buffer:
                    line, buffer = buffer.split(b"\n", 1)
                    line = line.decode("utf-8", errors="replace").strip()
                    if line:
                        pending = read_pending()
                        pending = handle_event(line, pending)
                        write_pending(pending)

        except (ConnectionRefusedError, FileNotFoundError, OSError) as e:
            print(f"ws-tracker: Connection error: {e}, retrying in 2s...", file=sys.stderr)
            time.sleep(2)
        except KeyboardInterrupt:
            print("ws-tracker: Shutting down", file=sys.stderr)
            break
        finally:
            try:
                sock.close()
            except:
                pass

if __name__ == "__main__":
    main()
