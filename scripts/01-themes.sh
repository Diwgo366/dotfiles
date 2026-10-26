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

sudo pacman -S --needed ttf-cascadia-mono-nerd inkscape xorg-xcursorgen

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "==> Instalando TokyoNight GTK..."
git clone --depth 1 https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git \
    "$tmp_dir/Tokyonight-GTK-Theme"

tokyonight_dir="$HOME/.themes/Tokyonight-BL-LB-Dark"
if [[ -e "$tokyonight_dir" || -L "$tokyonight_dir" ]]; then
    rm -rf -- "$tokyonight_dir"
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
        rm -rf -- "$target_path"
    fi
    ln -s -- "$source_path" "$target_path"
done

echo "==> Compilando Future Cursors Cyan..."
cursor_repo="$tmp_dir/Future-cursors"
git clone --depth 1 https://github.com/yeyushengfan258/Future-cursors.git "$cursor_repo"

# El build oficial compila src/svg por defecto; seleccionar la variante cyan.
sed -i \
    -e 's/^THEME="Future Cursors"$/THEME="Future Cursors Cyan"/' \
    -e 's/^create svg$/create svg-cyan/' \
    "$cursor_repo/build.sh"

(cd "$cursor_repo" && bash build.sh)

cursor_source="$cursor_repo/dist"
if [[ ! -f "$cursor_source/index.theme" || ! -d "$cursor_source/cursors" ]]; then
    echo "El build no generó un tema XCursor válido en $cursor_source." >&2
    exit 1
fi

# El repositorio ya trae index.theme, por eso el build no actualiza su nombre.
if grep -q '^Name=' "$cursor_source/index.theme"; then
    sed -i 's/^Name=.*/Name=Future Cursors Cyan/' "$cursor_source/index.theme"
else
    sed -i '/^\[Icon Theme\]/a Name=Future Cursors Cyan' "$cursor_source/index.theme"
fi

cursor_name="Future-cursors-cyan"
cursor_dir="$HOME/.local/share/icons/$cursor_name"

mkdir -p "$(dirname "$cursor_dir")"
if [[ -e "$cursor_dir" || -L "$cursor_dir" ]]; then
    rm -rf -- "$cursor_dir"
fi
cp -a -- "$cursor_source" "$cursor_dir"

fc-cache -f

if ! command -v gsettings >/dev/null 2>&1; then
    echo "Falta gsettings (paquete glib2); no se pueden activar los temas." >&2
    exit 1
fi

# Persiste las preferencias en la configuración GSettings del usuario actual.
set_gsetting() {
    local key=$1
    local value=$2
    local actual

    gsettings set org.gnome.desktop.interface "$key" "$value"
    actual="$(gsettings get org.gnome.desktop.interface "$key")"
    if [[ $actual != "'$value'" ]]; then
        echo "No se pudo aplicar $key='$value' (valor actual: $actual)." >&2
        echo "Ejecuta este instalador desde una sesión de usuario con D-Bus activo." >&2
        exit 1
    fi
}

set_gsetting gtk-theme 'Tokyonight-BL-LB-Dark'
set_gsetting icon-theme 'Papirus'
set_gsetting cursor-theme "$cursor_name"
set_gsetting font-name 'CaskaydiaMono Nerd Font 10'
set_gsetting monospace-font-name 'CaskaydiaMono Nerd Font Mono 10'
set_gsetting color-scheme 'prefer-dark'

echo "Tema GTK: $(gsettings get org.gnome.desktop.interface gtk-theme)"
echo "Esquema de color: $(gsettings get org.gnome.desktop.interface color-scheme)"
echo "TokyoNight, $cursor_name y CaskaydiaMono Nerd Font instalados y activados."
