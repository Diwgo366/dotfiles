#!/usr/bin/env bash
# Remove temporary numbered JPEGs (1.jpeg through 10.jpeg) from Downloads.
set -u

if [[ -n "${XDG_DOWNLOAD_DIR:-}" ]]; then
    download_dir=${XDG_DOWNLOAD_DIR/#\~/$HOME}
elif command -v xdg-user-dir >/dev/null 2>&1 && configured_dir=$(xdg-user-dir DOWNLOAD) && [[ -n "$configured_dir" ]]; then
    download_dir="$configured_dir"
elif [[ -d "$HOME/Downloads" ]]; then
    download_dir="$HOME/Downloads"
else
    download_dir="$HOME/Descargas"
fi

if [[ ! -d "$download_dir" ]]; then
    printf 'No existe la carpeta de descargas: %s\n' "$download_dir" >&2
    exit 1
fi

while :; do
    # Only remove regular files directly inside the downloads folder.
    find "$download_dir" -maxdepth 1 -type f -regextype posix-extended -regex '.*/([1-9]|10)\.jpeg' -mmin +9 -delete
    sleep 1800
done
