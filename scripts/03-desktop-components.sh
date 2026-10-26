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

for command_name in git sudo; do
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

backup_suffix="before-dotfiles-links.$(date +%Y%m%d%H%M%S)"

link_user_path() {
    local source=$1
    local target=$2
    local source_real
    local target_real

    source_real="$(readlink -f -- "$source")"
    if [[ -L $target ]]; then
        target_real="$(readlink -f -- "$target" 2>/dev/null || true)"
        if [[ $target_real == "$source_real" ]]; then
            return 0
        fi
    fi

    mkdir -p "$(dirname -- "$target")"
    if [[ -e $target || -L $target ]]; then
        mv -- "$target" "$target.$backup_suffix"
    fi
    ln -s -- "$source" "$target"
}

link_system_path() {
    local source=$1
    local target=$2
    local source_real
    local target_real

    source_real="$(readlink -f -- "$source")"
    if [[ -L $target ]]; then
        target_real="$(readlink -f -- "$target" 2>/dev/null || true)"
        if [[ $target_real == "$source_real" ]]; then
            return 0
        fi
    fi

    sudo mkdir -p "$(dirname -- "$target")"
    if [[ -e $target || -L $target ]]; then
        sudo mv -- "$target" "$target.$backup_suffix"
    fi
    sudo ln -s -- "$source" "$target"
}

metadata="$SDDM_THEME_DIR/metadata.desktop"
if [[ ! -f $metadata ]]; then
    echo "No se encontró $metadata después de instalar SilentSDDM." >&2
    exit 1
fi
sudo sed -i \
    -e '/^[[:space:]]*ConfigFile[[:space:]]*=/s/^/# /' \
    -e 's/^# *ConfigFile=configs\/space\.conf$/ConfigFile=configs\/space.conf/' \
    "$metadata"

echo "==> Enlazando wallpapers e imágenes de perfil..."
mkdir -p "$HOME/Media/Imágenes"
for media_name in wallpapers profile; do
    source="$DOTFILES/Media/Imágenes/$media_name"
    if [[ ! -d $source ]]; then
        echo "Falta el directorio $source." >&2
        exit 1
    fi
    link_user_path "$source" "$HOME/Media/Imágenes/$media_name"
done

echo "==> Enlazando los archivos especiales de SDDM..."
for relative_path in configs/space.conf icons/lock.svg backgrounds/space.png; do
    source="$DOTFILES/sddm/usr/share/sddm/themes/silent/$relative_path"
    target="$SDDM_THEME_DIR/$relative_path"
    if [[ ! -f $source ]]; then
        echo "Falta el archivo $source." >&2
        exit 1
    fi
    link_system_path "$source" "$target"
done

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

collect_traverse_dirs() {
    local path=$1
    local directory
    directory="$(dirname -- "$path")"

    while [[ $directory != / ]]; do
        printf '%s\n' "$directory"
        directory="$(dirname -- "$directory")"
    done
}

ensure_sddm_traverse() {
    local -a dirs=()
    local -a missing=()
    local path directory check_output

    for path in "$@"; do
        while IFS= read -r directory; do
            dirs+=("$directory")
        done < <(collect_traverse_dirs "$path")
    done

    ((${#dirs[@]})) || return 0
    mapfile -t dirs < <(printf '%s\n' "${dirs[@]}" | sort -u)

    check_output="$(sudo -u "$SDDM_USER" bash -c '
        for directory in "$@"; do
            [[ -x $directory ]] || printf "%s\n" "$directory"
        done
    ' _ "${dirs[@]}")" || {
        echo "No se pudo verificar el acceso de '$SDDM_USER' a los directorios." >&2
        return 1
    }

    if [[ -n $check_output ]]; then
        mapfile -t missing <<< "$check_output"
    fi

    for directory in "${missing[@]}"; do
        echo "==> Dando permiso de atravesar $directory al usuario $SDDM_USER..."
        if ! sudo setfacl -m "u:$SDDM_USER:x" "$directory"; then
            echo "No se pudo aplicar el ACL en $directory." >&2
            return 1
        fi
    done

    if ((${#missing[@]})); then
        check_output="$(sudo -u "$SDDM_USER" bash -c '
            for directory in "$@"; do
                [[ -x $directory ]] || printf "%s\n" "$directory"
            done
        ' _ "${missing[@]}")" || {
            echo "No se pudo verificar el acceso de '$SDDM_USER' a los directorios." >&2
            return 1
        }
        if [[ -n $check_output ]]; then
            echo "El usuario '$SDDM_USER' sigue sin poder atravesar:" >&2
            printf '  %s\n' "$check_output" >&2
            return 1
        fi
    fi
}

targets=()
paths_to_check=()
for relative_path in configs/space.conf icons/lock.svg backgrounds/space.png; do
    target="$SDDM_THEME_DIR/$relative_path"

    if [[ ! -e $target ]]; then
        echo "No existe $target o su enlace está roto; no se puede verificar el acceso de SDDM." >&2
        exit 1
    fi

    resolved_target="$(readlink -f -- "$target" 2>/dev/null || true)"
    if [[ -z $resolved_target ]]; then
        echo "No se pudo resolver el enlace $target." >&2
        exit 1
    fi

    targets+=("$target")
    paths_to_check+=("$target" "$resolved_target")
done

ensure_sddm_traverse "${paths_to_check[@]}" || exit 1

check_output="$(sudo -u "$SDDM_USER" bash -c '
    for file in "$@"; do
        [[ -r $file ]] || printf "%s\n" "$file"
    done
' _ "${targets[@]}")" || {
    echo "No se pudo verificar la lectura de los archivos de SDDM." >&2
    exit 1
}

if [[ -n $check_output ]]; then
    mapfile -t unreadable <<< "$check_output"
    for target in "${unreadable[@]}"; do
        resolved_target="$(readlink -f -- "$target" 2>/dev/null || true)"
        echo "==> Permitiendo al usuario $SDDM_USER leer $resolved_target..."
        if ! sudo setfacl -m "u:$SDDM_USER:r" "$resolved_target"; then
            echo "No se pudo dar permiso de lectura a '$SDDM_USER' en $resolved_target." >&2
            exit 1
        fi
    done
fi

check_output="$(sudo -u "$SDDM_USER" bash -c '
    for file in "$@"; do
        [[ -r $file ]] || printf "%s\n" "$file"
    done
' _ "${targets[@]}")" || {
    echo "No se pudo verificar la lectura de los archivos de SDDM." >&2
    exit 1
}

if [[ -n $check_output ]]; then
    echo "El usuario '$SDDM_USER' no puede leer:" >&2
    printf '  %s\n' "$check_output" >&2
    exit 1
fi

echo "SDDM puede atravesar $HOME y leer los archivos enlazados del tema."
