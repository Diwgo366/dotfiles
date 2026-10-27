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

echo "==> Instalando Graphite GTK (default, dark)..."
git clone --depth 1 https://github.com/vinceliuice/Graphite-gtk-theme.git \
    "$tmp_dir/Graphite-gtk-theme"

mkdir -p "$HOME/.themes"
"$tmp_dir/Graphite-gtk-theme/install.sh" \
    --dest "$HOME/.themes" \
    --theme default \
    --color dark \
    --size standard \
    --libadwaita

# Confirma que Graphite generó los archivos para GTK 3 y GTK 4.
graphite_theme_name='Graphite-Dark'
graphite_theme_dir="$HOME/.themes/$graphite_theme_name"
gtk3_source="$graphite_theme_dir/gtk-3.0"
gtk4_source="$graphite_theme_dir/gtk-4.0"
for gtk_dir in "$gtk3_source" "$gtk4_source"; do
    for required_file in gtk.css gtk-dark.css; do
        if [[ ! -f "$gtk_dir/$required_file" ]]; then
            echo "Falta un archivo del tema Graphite: $gtk_dir/$required_file" >&2
            exit 1
        fi
    done
done

# GTK4/libadwaita carga la configuración instalada por --libadwaita.
gtk4_target="$HOME/.config/gtk-4.0"

mkdir -p "$gtk4_target"
if [[ ! -f "$gtk4_target/gtk.css" || ! -L "$gtk4_target/gtk.css" \
    || ! -f "$gtk4_target/gtk-dark.css" || ! -L "$gtk4_target/gtk-dark.css" \
    || ! -d "$gtk4_target/assets" || ! -L "$gtk4_target/assets" ]]; then
    echo "Graphite no configuró GTK4/libadwaita en $gtk4_target." >&2
    exit 1
fi

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

set_gsetting gtk-theme "$graphite_theme_name"
set_gsetting icon-theme 'Papirus'
set_gsetting cursor-theme "$cursor_name"
set_gsetting font-name 'CaskaydiaMono Nerd Font 10'
set_gsetting monospace-font-name 'CaskaydiaMono Nerd Font Mono 10'
set_gsetting color-scheme 'prefer-dark'

echo "Tema GTK: $(gsettings get org.gnome.desktop.interface gtk-theme)"
echo "Esquema de color: $(gsettings get org.gnome.desktop.interface color-scheme)"
echo "$graphite_theme_name, $cursor_name y CaskaydiaMono Nerd Font instalados y activados."
