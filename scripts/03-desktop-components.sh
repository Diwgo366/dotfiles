#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    if [[ -n ${SUDO_USER:-} && ${SUDO_USER:-} != root ]]; then
        script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
        exec sudo -u "$SUDO_USER" -H bash "$script_path" "$@"
    fi
    echo "No ejecutes este script como root: instala los archivos en el HOME del usuario." >&2
    exit 1
fi

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
AGS_DIR="${AGS_DIR:-$HOME/Proyectos/ags}"
SDDM_THEME_DIR="/usr/share/sddm/themes/silent"
SDDM_USER="${SDDM_USER:-sddm}"
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

sudo pacman -S --needed acl git stow sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt6-imageformats

if sudo test -f "$SDDM_THEME_DIR/metadata.desktop"; then
    echo "==> SilentSDDM ya está instalado en $SDDM_THEME_DIR; se omite la reinstalación."
else
    echo "==> Instalando SilentSDDM..."
    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"' EXIT
    git clone --depth 1 "$SDDM_REPO_URL" "$tmp_dir/SilentSDDM"
    (cd "$tmp_dir/SilentSDDM" && ./install.sh)
fi

backup_suffix="before-dotfiles-stow.$(date +%Y%m%d%H%M%S)"
for relative_path in configs/space.conf icons/lock.svg backgrounds/space.png; do
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
sudo stow -D -d "$DOTFILES/sddm" -t / usr 2>/dev/null || true
sudo stow --restow -d "$DOTFILES" -t / sddm

echo "==> Permitiendo al usuario $SDDM_USER atravesar $HOME..."
if ! id -u "$SDDM_USER" >/dev/null 2>&1; then
    echo "No existe el usuario '$SDDM_USER'; no se puede configurar el ACL para SDDM." >&2
    exit 1
fi

if ! command -v setfacl >/dev/null 2>&1; then
    echo "Falta setfacl (paquete acl). Instálalo y vuelve a ejecutar el instalador." >&2
    exit 1
fi

if ! sudo setfacl -m "u:$SDDM_USER:x" "$HOME"; then
    echo "No se pudo dar permiso de atravesar $HOME al usuario '$SDDM_USER'." >&2
    echo "Verifica que el sistema de archivos soporte ACL (paquete acl)." >&2
    exit 1
fi

if ! sudo -u "$SDDM_USER" test -x "$HOME"; then
    echo "El usuario '$SDDM_USER' no puede atravesar $HOME." >&2
    echo "Revisa los permisos de los directorios superiores con: namei -l $HOME" >&2
    exit 1
fi

ensure_sddm_traverse() {
    local path=$1
    local directory
    directory="$(dirname -- "$path")"

    while [[ $directory != / ]]; do
        if ! sudo -u "$SDDM_USER" test -x "$directory"; then
            echo "==> Dando permiso de atravesar $directory al usuario $SDDM_USER..."
            if ! sudo setfacl -m "u:$SDDM_USER:x" "$directory"; then
                echo "No se pudo aplicar el ACL en $directory." >&2
                return 1
            fi
            if ! sudo -u "$SDDM_USER" test -x "$directory"; then
                echo "El usuario '$SDDM_USER' sigue sin poder atravesar $directory." >&2
                return 1
            fi
        fi
        directory="$(dirname -- "$directory")"
    done
}

for relative_path in configs/space.conf icons/lock.svg backgrounds/space.png; do
    target="$SDDM_THEME_DIR/$relative_path"

    if ! sudo test -e "$target"; then
        echo "No existe $target o su enlace está roto; no se puede verificar el acceso de SDDM." >&2
        exit 1
    fi

    resolved_target="$(sudo readlink -f -- "$target" 2>/dev/null || true)"
    if [[ -z $resolved_target ]]; then
        echo "No se pudo resolver el enlace $target." >&2
        exit 1
    fi

    ensure_sddm_traverse "$target"
    ensure_sddm_traverse "$resolved_target"

    if ! sudo -u "$SDDM_USER" test -r "$resolved_target"; then
        echo "==> Permitiendo al usuario $SDDM_USER leer $resolved_target..."
        if ! sudo setfacl -m "u:$SDDM_USER:r" "$resolved_target"; then
            echo "No se pudo dar permiso de lectura a '$SDDM_USER' en $resolved_target." >&2
            exit 1
        fi
    fi

    if ! sudo -u "$SDDM_USER" test -r "$target"; then
        echo "El usuario '$SDDM_USER' no puede leer $target." >&2
        echo "Ruta del enlace:" >&2
        sudo namei -l -- "$target" >&2 || true
        echo "Ruta resuelta:" >&2
        sudo namei -l -- "$resolved_target" >&2 || true
        exit 1
    fi
done

echo "SDDM puede atravesar $HOME y leer los archivos enlazados del tema."
