#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
ROOT_DIR="$(dirname -- "$SCRIPT_PATH")"
SCRIPTS_DIR="$ROOT_DIR/scripts"
ORIGINAL_ARGS=("$@")

if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'
    C_INFO=$'\033[1;34m'
    C_OK=$'\033[1;32m'
    C_WARN=$'\033[1;33m'
    C_ERROR=$'\033[1;31m'
else
    C_RESET=''
    C_INFO=''
    C_OK=''
    C_WARN=''
    C_ERROR=''
fi

info() { printf '%s==>%s %s\n' "$C_INFO" "$C_RESET" "$*"; }
ok() { printf '%s==>%s %s\n' "$C_OK" "$C_RESET" "$*"; }
warn() { printf '%sAdvertencia:%s %s\n' "$C_WARN" "$C_RESET" "$*" >&2; }
error() { printf '%sError:%s %s\n' "$C_ERROR" "$C_RESET" "$*" >&2; }
die() { error "$*"; exit 1; }

usage() {
    cat <<'EOF'
Uso: install.sh [opciones]

Ejecuta en orden los scripts de scripts/*.sh. Ejecútalo como tu usuario
normal: el instalador baja privilegios automáticamente si detecta sudo y
cada script pide sudo solo para las acciones que lo necesitan (pacman,
SDDM, etc.). yay y AUR nunca se ejecutan como root.

Opciones:
  -h, --help                Muestra esta ayuda.
  -l, --list                Lista los scripts disponibles.
  -n, --dry-run             Muestra lo que se ejecutaría sin ejecutarlo.
  -k, --keep-going          Continúa con el siguiente script aunque uno falle.
      --only NOMBRE,...     Ejecuta solo los scripts indicados.
      --skip NOMBRE,...     Omite los scripts indicados.

NOMBRE puede ser el nombre completo (00-packages.sh), sin extensión
(00-packages) o su prefijo (00).

Ejemplos:
  ./install.sh --skip 01-themes --skip 03-desktop-components
  ./install.sh --only 00-packages,02-stow-dotfiles
  ./install.sh --keep-going
EOF
}

append_names() {
    local -n destination=$1
    local value=$2
    local part
    local -a parts=()

    IFS=',' read -r -a parts <<< "$value"
    for part in "${parts[@]}"; do
        part="${part#"${part%%[![:space:]]*}"}"
        part="${part%"${part##*[![:space:]]}"}"
        part="${part%.sh}"
        if [[ -n $part ]]; then
            destination+=("$part")
        fi
    done
}

name_matches() {
    local stem=$1
    local wanted=$2
    [[ $stem == "$wanted" || $stem == "$wanted"-* ]]
}

validate_selection() {
    local -n wanted_names=$1
    local option_name=$2
    local wanted script found

    ((${#wanted_names[@]})) || return 0
    for wanted in "${wanted_names[@]}"; do
        found=0
        for script in "${scripts[@]}"; do
            if name_matches "$(basename -- "$script" .sh)" "$wanted"; then
                found=1
                break
            fi
        done
        ((found)) || die "No existe ningún script que coincida con '$wanted' (opción --$option_name)."
    done
}

dry_run=0
keep_going=0
list_only=0
only_specified=0
skip_specified=0
only_names=()
skip_names=()

while (($#)); do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -l|--list)
            list_only=1
            ;;
        -n|--dry-run)
            dry_run=1
            ;;
        -k|--keep-going|--continue-on-error)
            keep_going=1
            ;;
        --only)
            (($# >= 2)) || die "Falta el valor para --only."
            only_specified=1
            append_names only_names "$2"
            shift
            ;;
        --only=*)
            only_specified=1
            append_names only_names "${1#*=}"
            ;;
        --skip)
            (($# >= 2)) || die "Falta el valor para --skip."
            skip_specified=1
            append_names skip_names "$2"
            shift
            ;;
        --skip=*)
            skip_specified=1
            append_names skip_names "${1#*=}"
            ;;
        --)
            shift
            (($# == 0)) || die "Argumentos no esperados: $*"
            break
            ;;
        -*)
            die "Opción desconocida: $1 (usa --help)."
            ;;
        *)
            die "Argumento no esperado: $1 (usa --help)."
            ;;
    esac
    shift
done

if [[ ! -d $SCRIPTS_DIR ]]; then
    die "No existe el directorio de scripts: $SCRIPTS_DIR"
fi

mapfile -d '' scripts < <(
    find "$SCRIPTS_DIR" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z
)

if ((${#scripts[@]} == 0)); then
    die "No hay scripts .sh en $SCRIPTS_DIR"
fi

if ((only_specified)) && ((${#only_names[@]} == 0)); then
    die "No se indicó ningún nombre válido para --only."
fi
if ((skip_specified)) && ((${#skip_names[@]} == 0)); then
    die "No se indicó ningún nombre válido para --skip."
fi

validate_selection only_names only
validate_selection skip_names skip

selected=()
for script in "${scripts[@]}"; do
    stem="$(basename -- "$script" .sh)"

    if ((${#only_names[@]})); then
        include=0
        for wanted in "${only_names[@]}"; do
            if name_matches "$stem" "$wanted"; then
                include=1
                break
            fi
        done
        ((include)) || continue
    fi

    if ((${#skip_names[@]})); then
        exclude=0
        for wanted in "${skip_names[@]}"; do
            if name_matches "$stem" "$wanted"; then
                exclude=1
                break
            fi
        done
        ((exclude)) && continue
    fi

    selected+=("$script")
done

if ((list_only)); then
    printf 'Scripts disponibles en %s:\n' "$SCRIPTS_DIR"
    for script in "${scripts[@]}"; do
        printf '  %s\n' "$(basename -- "$script")"
    done
    exit 0
fi

if ((${#selected[@]} == 0)); then
    die "No queda ningún script por ejecutar con los filtros indicados."
fi

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    if [[ -n ${SUDO_USER:-} && ${SUDO_USER:-} != root ]]; then
        target_user=$SUDO_USER
        target_home="$(getent passwd "$target_user" | cut -d: -f6)"
        [[ -n $target_home ]] || die "No se pudo determinar el HOME de '$target_user'."
        info "sudo detectado: se ejecutará como '$target_user' (yay, AUR y stow no deben correr como root)."
        exec sudo -u "$target_user" -H env \
            HOME="$target_home" \
            USER="$target_user" \
            LOGNAME="$target_user" \
            bash "$SCRIPT_PATH" "${ORIGINAL_ARGS[@]}"
    fi
    die "No ejecutes este instalador como root. Usa tu usuario normal; se pedirá sudo solo cuando sea necesario."
fi

if ((!dry_run)); then
    needs_sudo=0
    for script in "${selected[@]}"; do
        if grep -qE '(^|[[:space:]])sudo([[:space:]]|$)' "$script"; then
            needs_sudo=1
            break
        fi
    done

    if ((needs_sudo)); then
        if command -v sudo >/dev/null 2>&1; then
            info "Solicitando permisos de sudo una sola vez..."
            sudo -v || die "No se pudieron obtener permisos de sudo."
        else
            warn "sudo no está instalado; los scripts que lo requieran fallarán."
        fi
    fi
fi

on_error() {
    local status=$?
    error "Fallo inesperado en install.sh (línea $LINENO, código $status)."
    exit "$status"
}
trap on_error ERR

failures=()

for script in "${selected[@]}"; do
    script_name="$(basename -- "$script")"
    info "Ejecutando $script_name"

    if ((dry_run)); then
        printf '  (simulación) bash %q\n' "$script"
        continue
    fi

    if bash "$script"; then
        ok "$script_name completado."
    else
        status=$?
        failures+=("$script_name (código $status)")
        error "$script_name falló con código $status."
        if ((!keep_going)); then
            error "Instalación interrumpida. Usa --keep-going para continuar con los scripts restantes."
            exit "$status"
        fi
        warn "Se continúa con el siguiente script por --keep-going."
    fi
done

if ((${#failures[@]})); then
    error "La instalación terminó con ${#failures[@]} script(s) fallido(s):"
    for failure in "${failures[@]}"; do
        printf '  - %s\n' "$failure" >&2
    done
    exit 1
fi

ok "Instalación completa."
