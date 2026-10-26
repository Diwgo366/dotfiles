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
        rm -rf -- "$target"
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
        sudo rm -rf -- "$target"
    fi
    sudo ln -s -- "$source" "$target"
}

metadata="$SDDM_THEME_DIR/metadata.desktop"
if [[ ! -f $metadata ]]; then
    echo "No se encontró $metadata después de instalar SilentSDDM." >&2
    exit 1
fi
metadata_tmp="$(mktemp)"
awk '
    function ensure_space_config() {
        if (in_theme && !space_config_seen) {
            print "ConfigFile=configs/space.conf"
            space_config_seen = 1
        }
    }

    /^\[[^]]+\]$/ {
        ensure_space_config()
        in_theme = ($0 == "[SddmGreeterTheme]")
        print
        next
    }

    in_theme && /^[[:space:]]*#?[[:space:]]*ConfigFile[[:space:]]*=/ {
        normalized = $0
        sub(/^[[:space:]]*#[[:space:]]*/, "", normalized)
        sub(/^[[:space:]]*/, "", normalized)
        sub(/[[:space:]]*$/, "", normalized)
        if (normalized == "ConfigFile=configs/space.conf") {
            if (!space_config_seen)
                print "ConfigFile=configs/space.conf"
            else
                print "# ConfigFile=configs/space.conf"
            space_config_seen = 1
        } else if ($0 !~ /^[[:space:]]*#/) {
            print "# " $0
        } else {
            print
        }
        next
    }

    { print }

    END { ensure_space_config() }
' "$metadata" > "$metadata_tmp"
if ! sudo install -o root -g root -m 0644 "$metadata_tmp" "$metadata"; then
    rm -f -- "$metadata_tmp"
    echo "No se pudo actualizar $metadata." >&2
    exit 1
fi
rm -f -- "$metadata_tmp"

if ! sudo awk '
    /^\[SddmGreeterTheme\]$/ { in_theme = 1; next }
    /^\[/ { in_theme = 0 }
    in_theme && $0 == "ConfigFile=configs/space.conf" { count++ }
    END { exit count != 1 }
' "$metadata"; then
    echo "No se pudo activar ConfigFile=configs/space.conf en $metadata." >&2
    exit 1
fi

echo "==> Consolidando la configuración de SDDM y activando Bloq Num..."
sddm_config_tmp="$(mktemp)"
sddm_config_source=/etc/sddm.conf
if ! sudo test -r "$sddm_config_source"; then
    sddm_config_source=/dev/null
fi
awk '
    function emit_missing(section) {
        if (section == "[Theme]" && !has_current) {
            print "Current=silent"
            has_current = 1
        }
        if (section == "[General]") {
            if (!has_input_method) {
                print "InputMethod=qtvirtualkeyboard"
                has_input_method = 1
            }
            if (!has_greeter_environment) {
                print "GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard"
                has_greeter_environment = 1
            }
            if (!has_numlock) {
                print "Numlock=on"
                has_numlock = 1
            }
        }
    }

    /^\[[^]]+\]$/ {
        next_section = $0
        if (section != next_section && section != "")
            emit_missing(section)
        section = next_section
        if (!seen[section]++)
            print
        next
    }

    section == "[Theme]" && /^[[:space:]]*Current[[:space:]]*=/ {
        if (!has_current)
            print "Current=silent"
        has_current = 1
        next
    }

    section == "[General]" && /^[[:space:]]*InputMethod[[:space:]]*=/ {
        if (!has_input_method)
            print "InputMethod=qtvirtualkeyboard"
        has_input_method = 1
        next
    }

    section == "[General]" && /^[[:space:]]*GreeterEnvironment[[:space:]]*=/ {
        if (!has_greeter_environment)
            print "GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard"
        has_greeter_environment = 1
        next
    }

    section == "[General]" && /^[[:space:]]*Numlock[[:space:]]*=/ {
        if (!has_numlock)
            print "Numlock=on"
        has_numlock = 1
        next
    }

    { print }

    END {
        if (section != "")
            emit_missing(section)
        if (!seen["[Theme]"]) {
            print "[Theme]"
            emit_missing("[Theme]")
        }
        if (!seen["[General]"]) {
            print "[General]"
            emit_missing("[General]")
        }
    }
' "$sddm_config_source" > "$sddm_config_tmp"
if ! sudo install -o root -g root -m 0644 "$sddm_config_tmp" /etc/sddm.conf; then
    rm -f -- "$sddm_config_tmp"
    echo "No se pudo actualizar /etc/sddm.conf." >&2
    exit 1
fi
rm -f -- "$sddm_config_tmp"
if ! sudo awk '
    /^\[Theme\]$/ { theme_count++; section = "Theme"; next }
    /^\[General\]$/ { general_count++; section = "General"; next }
    /^\[/ { section = "" }
    section == "Theme" && /^Current=silent$/ { current_count++ }
    section == "General" && /^InputMethod=qtvirtualkeyboard$/ { input_count++ }
    section == "General" && /^GreeterEnvironment=QML2_IMPORT_PATH=\/usr\/share\/sddm\/themes\/silent\/components\/,QT_IM_MODULE=qtvirtualkeyboard$/ { environment_count++ }
    section == "General" && /^Numlock=on$/ { numlock_count++ }
    END {
        exit !(theme_count == 1 && general_count == 1 && current_count == 1 &&
               input_count == 1 && environment_count == 1 && numlock_count == 1)
    }
' /etc/sddm.conf; then
    echo "/etc/sddm.conf no quedó normalizado como se esperaba." >&2
    exit 1
fi

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

targets=()
resolved_targets=()
for relative_path in configs/space.conf icons/lock.svg backgrounds/space.png; do
    target="$SDDM_THEME_DIR/$relative_path"

    if [[ ! -e $target ]]; then
        echo "No existe $target o su enlace está roto; no se puede verificar el acceso de SDDM." >&2
        exit 1
    fi

    targets+=("$target")
    resolved_target="$(readlink -f -- "$target" 2>/dev/null || true)"
    if [[ -z $resolved_target ]]; then
        echo "No se pudo resolver el enlace $target." >&2
        exit 1
    fi
    resolved_targets+=("$resolved_target")
done

echo "==> Verificando directorios necesarios para acceder a los enlaces..."
directories=()
for path in "${targets[@]}" "${resolved_targets[@]}"; do
    directory="$(dirname -- "$path")"
    while [[ $directory != / ]]; do
        directories+=("$directory")
        directory="$(dirname -- "$directory")"
    done
done
mapfile -t directories < <(printf '%s\n' "${directories[@]}" | sort -u)

missing_directories="$(sudo -u "$SDDM_USER" bash -c '
    for directory in "$@"; do
        [[ -x $directory ]] || printf "%s\n" "$directory"
    done
' _ "${directories[@]}")" || {
    echo "No se pudo comprobar el acceso de '$SDDM_USER' a los directorios." >&2
    exit 1
}

if [[ -n $missing_directories ]]; then
    mapfile -t missing_directory_list <<< "$missing_directories"
    for directory in "${missing_directory_list[@]}"; do
        echo "==> Permitiendo a $SDDM_USER atravesar $directory..."
        if ! sudo setfacl -m "u:$SDDM_USER:x" "$directory"; then
            echo "No se pudo dar permiso de atravesar $directory al usuario '$SDDM_USER'." >&2
            echo "Verifica que el sistema de archivos soporte ACL (paquete acl)." >&2
            exit 1
        fi
    done

    still_missing="$(sudo -u "$SDDM_USER" bash -c '
        for directory in "$@"; do
            [[ -x $directory ]] || printf "%s\n" "$directory"
        done
    ' _ "${missing_directory_list[@]}")"
    if [[ -n $still_missing ]]; then
        echo "SDDM sigue sin poder atravesar estos directorios:" >&2
        printf '  %s\n' "$still_missing" >&2
        exit 1
    fi
fi

echo "==> Verificando que $SDDM_USER puede leer los archivos del tema..."
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
    while IFS= read -r target; do
        sudo namei -l -- "$target" >&2 || true
    done <<< "$check_output"
    exit 1
fi

echo "SDDM puede leer los archivos enlazados del tema."
