#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
AGS_DIR="${AGS_DIR:-$HOME/Proyectos/ags}"
SDDM_THEME_DIR="/usr/share/sddm/themes/silent"
SDDM_REPO_URL="https://github.com/uiriansan/SilentSDDM.git"
AGS_REPO_URL="https://github.com/Diwgo366/ags-bar.git"

for command_name in git stow sudo; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Falta el comando requerido: $command_name" >&2
        exit 1
    fi
done

if ! command -v pacman >/dev/null 2>&1; then
    echo "Este instalador requiere Arch Linux o una distribución con pacman." >&2
    exit 1
fi

echo "==> Clonando AGS bar en $AGS_DIR..."
if [[ -e "$AGS_DIR" ]]; then
    if git -C "$AGS_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Ya existe un repositorio Git en $AGS_DIR; se conserva sin actualizarlo."
    else
        echo "La ruta AGS_DIR ya existe y no es un repositorio Git: $AGS_DIR" >&2
        exit 1
    fi
else
    mkdir -p "$(dirname "$AGS_DIR")"
    git clone "$AGS_REPO_URL" "$AGS_DIR"
fi

echo "==> Instalando SilentSDDM..."
sudo pacman -S --needed git stow sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt6-imageformats

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
git clone --depth 1 "$SDDM_REPO_URL" "$tmp_dir/SilentSDDM"
(cd "$tmp_dir/SilentSDDM" && ./install.sh)

backup_suffix="before-dotfiles-stow.$(date +%Y%m%d%H%M%S)"
for relative_path in configs/space.conf icons/lock.svg; do
    target="$SDDM_THEME_DIR/$relative_path"
    if sudo test -e "$target" || sudo test -L "$target"; then
        sudo mv -- "$target" "$target.$backup_suffix"
    fi
done

metadata="$SDDM_THEME_DIR/metadata.desktop"
if ! sudo test -f "$metadata"; then
    echo "No se encontró $metadata después de instalar SilentSDDM." >&2
    exit 1
fi
sudo sed -i \
    -e '/^[[:space:]]*ConfigFile[[:space:]]*=/s/^/# /' \
    -e 's/^# *ConfigFile=configs\/space\.conf$/ConfigFile=configs\/space.conf/' \
    "$metadata"

echo "==> Stoweando wallpapers e imágenes de perfil..."
mkdir -p "$HOME/Media/Imágenes"
stow --restow -d "$DOTFILES/Media/Imágenes" -t "$HOME/Media/Imágenes" wallpapers profile

echo "==> Stoweando los archivos especiales de SDDM..."
sudo stow --restow -d "$DOTFILES/sddm" -t / usr

echo "AGS bar clonado, SilentSDDM instalado y casos especiales enlazados."
