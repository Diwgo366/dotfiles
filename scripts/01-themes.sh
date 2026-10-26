#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
    echo "Este instalador está preparado para Arch Linux y pacman." >&2
    exit 1
fi

for command_name in git tar; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Falta el comando requerido: $command_name" >&2
        exit 1
    fi
done

sudo pacman -S --needed ttf-cascadia-mono-nerd

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

backup_suffix="before-theme-install.$(date +%Y%m%d%H%M%S)-$$"

echo "==> Instalando TokyoNight GTK..."
git clone --depth 1 https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git \
    "$tmp_dir/Tokyonight-GTK-Theme"

tokyonight_dir="$HOME/.themes/Tokyonight-BL-LB-Dark"
if [[ -e "$tokyonight_dir" || -L "$tokyonight_dir" ]]; then
    mv -- "$tokyonight_dir" "$tokyonight_dir.$backup_suffix"
fi

"$tmp_dir/Tokyonight-GTK-Theme/themes/install.sh" \
    --dest "$HOME/.themes" \
    --name Tokyonight-BL-LB \
    --color dark

# GTK4/libadwaita lee el tema desde estos archivos de configuración del usuario.
gtk4_source="$tokyonight_dir/gtk-4.0"
gtk4_target="$HOME/.config/gtk-4.0"
mkdir -p "$gtk4_target"
for relative_path in assets gtk.css gtk-dark.css; do
    source_path="$gtk4_source/$relative_path"
    target_path="$gtk4_target/$relative_path"
    if [[ ! -e "$source_path" ]]; then
        echo "Falta el archivo GTK4 del tema: $source_path" >&2
        exit 1
    fi
    if [[ -e "$target_path" || -L "$target_path" ]]; then
        mv -- "$target_path" "$target_path.$backup_suffix"
    fi
    ln -s -- "$source_path" "$target_path"
done

echo "==> Instalando Future Cyan XCursor..."
git clone --depth 1 https://github.com/ChooChooAl/Cursors.git \
    "$tmp_dir/Cursors"

mkdir -p "$tmp_dir/future-cyan"
tar -xf "$tmp_dir/Cursors/Future-Cyan.tar" -C "$tmp_dir/future-cyan"

cursor_source="$(find "$tmp_dir/future-cyan" -type d -name cursors -printf '%h\n' -quit)"
if [[ -z "$cursor_source" || ! -f "$cursor_source/index.theme" ]]; then
    echo "El archivo Future-Cyan.tar no contiene un tema XCursor válido." >&2
    exit 1
fi

cursor_dir="$HOME/.local/share/icons/Future-cyan-cursors"
mkdir -p "$(dirname "$cursor_dir")"
if [[ -e "$cursor_dir" || -L "$cursor_dir" ]]; then
    mv -- "$cursor_dir" "$cursor_dir.$backup_suffix"
fi
mv -- "$cursor_source" "$cursor_dir"

fc-cache -f

# Activa los temas y fuentes en la sesión del usuario actual.
gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-BL-LB-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface cursor-theme 'Future-cyan-cursors'
gsettings set org.gnome.desktop.interface font-name 'CaskaydiaMono Nerd Font 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaMono Nerd Font Mono 10'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "TokyoNight, Future-cyan-cursors y CaskaydiaMono Nerd Font instalados."
