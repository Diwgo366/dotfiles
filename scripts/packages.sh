#!/usr/bin/env bash
# Instalador universal de paquetes
# Detecta el gestor de paquetes disponible e instala en consecuencia
# Soporta: apt, dnf, pacman, zypper, emerge, xbps, nix, brew, flatpak, snap, yay, paru

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LISTS_DIR="$SCRIPT_DIR/packages"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ==============================================================
# DETECCIÓN DE GESTOR DE PAQUETES
# ==============================================================

detect_pm() {
    local pm=""

    if command -v apt &>/dev/null; then
        pm="apt"
    elif command -v dnf &>/dev/null; then
        pm="dnf"
    elif command -v pacman &>/dev/null; then
        if command -v yay &>/dev/null; then
            pm="yay"
        elif command -v paru &>/dev/null; then
            pm="paru"
        else
            pm="pacman"
        fi
    elif command -v zypper &>/dev/null; then
        pm="zypper"
    elif command -v emerge &>/dev/null; then
        pm="emerge"
    elif command -v xbps-install &>/dev/null; then
        pm="xbps"
    elif command -v nix-env &>/dev/null; then
        pm="nix"
    elif command -v brew &>/dev/null; then
        pm="brew"
    elif command -v flatpak &>/dev/null; then
        pm="flatpak"
    elif command -v snap &>/dev/null; then
        pm="snap"
    fi

    echo "$pm"
}

PM=$(detect_pm)

# ==============================================================
# COMANDOS POR GESTOR
# ==============================================================

get_install_cmd() {
    local pm=$1
    shift
    local packages=("$@")

    case "$pm" in
        apt)
            echo "sudo apt install -y ${packages[*]}"
            ;;
        dnf)
            echo "sudo dnf install -y ${packages[*]}"
            ;;
        pacman)
            echo "sudo pacman -S --noconfirm ${packages[*]}"
            ;;
        yay)
            echo "yay -S --noconfirm ${packages[*]}"
            ;;
        paru)
            echo "paru -S --noconfirm ${packages[*]}"
            ;;
        zypper)
            echo "sudo zypper install -y ${packages[*]}"
            ;;
        emerge)
            echo "sudo emerge ${packages[*]}"
            ;;
        xbps)
            echo "sudo xbps-install -y ${packages[*]}"
            ;;
        nix)
            echo "nix-env -iA nixpkgs.${packages[*]}"
            ;;
        brew)
            echo "brew install ${packages[*]}"
            ;;
        flatpak)
            echo "flatpak install -y ${packages[*]}"
            ;;
        snap)
            echo "sudo snap install ${packages[*]}"
            ;;
        *)
            echo ""
            ;;
    esac
}

get_update_cmd() {
    local pm=$1

    case "$pm" in
        apt)    echo "sudo apt update" ;;
        dnf)    echo "sudo dnf check-update || true" ;;
        pacman|yay|paru) echo "sudo pacman -Sy" ;;
        zypper) echo "sudo zypper refresh" ;;
        emerge) echo "sudo emerge --sync" ;;
        xbps)   echo "sudo xbps-install -S" ;;
        nix)    echo "nix-channel --update" ;;
        brew)   echo "brew update" ;;
        flatpak) echo "flatpak update" ;;
        snap)   echo "sudo snap refresh" ;;
        *)      echo "" ;;
    esac
}

# ==============================================================
# FUNCIONES DE INSTALACIÓN
# ==============================================================

install_packages() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        return
    fi

    local cmd
    cmd=$(get_install_cmd "$PM" "${packages[@]}")

    if [[ -z "$cmd" ]]; then
        echo -e "${RED}✗ No se pudo determinar comando de instalación para: ${packages[*]}${NC}"
        return 1
    fi

    echo -e "${CYAN}▶ Ejecutando:${NC} $cmd"
    echo ""
    eval "$cmd" || {
        echo -e "${RED}✗ Error instalando: ${packages[*]}${NC}"
        return 1
    }
}

install_from_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}✗ Archivo no encontrado: $file${NC}"
        return 1
    fi

    local name
    name=$(basename "$file" .txt)
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${YELLOW}   Categoría: $name${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""

    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        pkg="${pkg%%#*}"   # quitar comentarios
        pkg="${pkg// /}"   # quitar espacios
        [[ -z "$pkg" ]] && continue
        install_packages "$pkg"
    done < "$file"

    echo ""
}

update_system() {
    local cmd
    cmd=$(get_update_cmd "$PM")

    if [[ -z "$cmd" ]]; then
        echo -e "${RED}✗ No se pudo determinar comando de actualización${NC}"
        return 1
    fi

    echo -e "${CYAN}▶ Actualizando repositorios...${NC}"
    eval "$cmd"
    echo -e "${GREEN}✓ Repositorios actualizados${NC}"
}

# ==============================================================
# HELP
# ==============================================================

show_header() {
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${BLUE}   Instalador Universal de Paquetes${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Gestor detectado: ${PM:-N/A}${NC}"
    echo ""
}

show_usage() {
    echo -e "${BLUE}Uso:${NC} $(basename "$0") [OPCIONES] [paquete...]"
    echo ""
    echo -e "${BLUE}Opciones:${NC}"
    echo "  --list, -l          Listar categorías disponibles"
    echo "  --show, -s         Mostrar paquetes de una categoría (ej: --show dev)"
    echo "  --install, -i       Instalar paquetes desde una o más categorías específicas"
    echo "  --all, -a           Instalar todas las categorías disponibles"
    echo "  --update, -u        Actualizar repositorios"
    echo "  -h, --help          Mostrar esta ayuda"
    echo ""
    echo -e "${BLUE}Ejemplos:${NC}"
    echo "  $(basename "$0") firefox vim git       # instalar paquetes específicos"
    echo "  $(basename "$0") --all                  # instalar todas las categorías"
    echo "  $(basename "$0") -i dev media          # instalar categorías específicas"
    echo "  $(basename "$0") --list                 # listar categorías"
    echo "  $(basename "$0") --show dev            # mostrar paquetes de 'dev'"
    echo "  $(basename "$0") --update               # actualizar repositorios"
    echo ""
}

list_categories() {
    echo -e "${YELLOW}Categorías disponibles:${NC}"
    echo ""
    for list in "$LISTS_DIR"/*.txt; do
        if [[ -f "$list" ]]; then
            name=$(basename "$list" .txt)
            count=$(grep -vE '^\s*(#|$)' "$list" 2>/dev/null | wc -l)
            printf "  ${CYAN}%-15s${NC} (%d paquetes)\n" "$name" "$count"
        fi
    done
    echo ""
}

show_category() {
    local file="$LISTS_DIR/$1.txt"
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}✗ Categoría no encontrada: $1${NC}"
        echo ""
        echo -e "${YELLOW}Categorías disponibles:${NC}"
        for f in "$LISTS_DIR"/*.txt; do
            echo "  $(basename "$f" .txt)"
        done
        echo ""
        exit 1
    fi

    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${BLUE}   Categoría: $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""

    while IFS= read -r line || [[ -n "$line" ]]; do
        pkg="${line%%#*}"
        pkg="${pkg// /}"
        if [[ -n "$pkg" ]]; then
            echo "  • $pkg"
        fi
    done < "$file"

    echo ""
}

# ==============================================================
# MAIN
# ==============================================================

main() {
    if [[ -z "$PM" ]]; then
        echo -e "${RED}✗ No se detectó ningún gestor de paquetes conocido${NC}"
        exit 1
    fi

    if [[ $# -eq 0 ]]; then
        show_header
        show_usage
        exit 0
    fi

    local categories=()
    local install_all=0
    local do_update=0
    local standalone_packages=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_header
                show_usage
                exit 0
                ;;
            --list|-l)
                show_header
                list_categories
                exit 0
                ;;
            --show|-s)
                shift
                if [[ $# -eq 0 ]]; then
                    echo -e "${RED}✗ Especificá una categoría (ej: --show dev)${NC}"
                    exit 1
                fi
                show_category "$1"
                exit 0
                ;;
            --all|-a)
                install_all=1
                ;;
            --update|-u)
                do_update=1
                ;;
            --install|-i)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                    categories+=("$1")
                    shift
                done
                continue
                ;;
            *)
                standalone_packages+=("$1")
                ;;
        esac
        shift
    done

    if [[ $do_update -eq 1 ]]; then
        update_system
        echo ""
    fi

    if [[ ${#standalone_packages[@]} -gt 0 ]]; then
        show_header
        echo -e "${YELLOW}Instalando paquetes individuales...${NC}"
        echo ""
        install_packages "${standalone_packages[@]}"
        echo ""
        return
    fi

    if [[ $install_all -eq 1 ]]; then
        categories=()
        for list in "$LISTS_DIR"/*.txt; do
            [[ -f "$list" ]] && categories+=("$(basename "$list" .txt)")
        done
    fi

    if [[ ${#categories[@]} -gt 0 ]]; then
        show_header
        echo -e "${YELLOW}Instalando categorías...${NC}"
        echo ""
        for cat_name in "${categories[@]}"; do
            install_from_file "$LISTS_DIR/$cat_name.txt"
        done
        echo -e "${GREEN}✓ ¡Completado!${NC}"
        echo ""
        return
    fi

    show_header
    show_usage
}

main "$@"
