#!/usr/bin/env bash
# Selector de temas de colores
# Ejecuta los scripts individuales de cada tema

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/colors/programs"

# Códigos de color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==============================================================
# FUNCIONES
# ==============================================================

show_header() {
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${BLUE}   Selector de Temas de Colores${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
}

show_usage() {
    cat << HELP
${BLUE}Uso:${NC} $(basename "$0") [OPCIONES]

${BLUE}Opciones:${NC}
  --all              Instalar todos los temas disponibles
  --kitty            Instalar tema Kitty
  --starship         Instalar tema Starship
  --nvim             Instalar tema Neovim
  --gnome            Instalar tema GNOME Terminal
  --mc               Instalar tema Midnight Commander (requiere sudo)
  --list             Listar temas disponibles
  -h, --help         Mostrar esta ayuda

${BLUE}Ejemplos:${NC}
  $(basename "$0") --all
  $(basename "$0") --kitty --starship --nvim
  sudo $(basename "$0") --mc
  $(basename "$0") --list

HELP
}

# Lista todos los temas disponibles
list_themes() {
    echo -e "${YELLOW}Temas disponibles:${NC}"
    echo ""
    
    for theme_script in "$THEMES_DIR"/*.sh; do
        if [[ -f "$theme_script" ]]; then
            theme_name=$(basename "$theme_script" .sh)
            echo "  • $theme_name"
        fi
    done
    
    echo ""
}

# Ejecuta un tema específico
run_theme() {
    local theme_name=$1
    local theme_script="$THEMES_DIR/$theme_name.sh"
    
    if [[ ! -f "$theme_script" ]]; then
        echo -e "${RED}✗ Tema no encontrado: $theme_name${NC}"
        return 1
    fi
    
    if [[ ! -x "$theme_script" ]]; then
        chmod +x "$theme_script"
    fi
    
    # MC requiere sudo, pasar al subprocess
    if [[ "$theme_name" == "mc" ]] && [[ "$EUID" -ne 0 ]]; then
        sudo bash "$theme_script"
    else
        bash "$theme_script"
    fi
}

# Menú interactivo
interactive_menu() {
    show_header
    
    declare -a selected
    declare -a theme_names=()
    declare -a theme_files=()
    
    # Cargar temas disponibles
    for theme_script in "$THEMES_DIR"/*.sh; do
        if [[ -f "$theme_script" ]]; then
            theme_name=$(basename "$theme_script" .sh)
            theme_names+=("$theme_name")
            theme_files+=("$theme_script")
        fi
    done
    
    while true; do
        echo -e "${YELLOW}Selecciona qué temas deseas instalar:${NC}"
        echo ""
        
        for i in "${!theme_names[@]}"; do
            idx=$((i + 1))
            theme="${theme_names[i]}"
            
            # Verificar si está seleccionado
            if [[ " ${selected[@]} " =~ " ${theme} " ]]; then
                echo -e "  ${GREEN}[✓]${NC} [$idx] $theme"
            else
                echo "  [ ] [$idx] $theme"
            fi
        done
        
        echo ""
        echo -e "  [$((${#theme_names[@]} + 1))] Instalar todos"
        echo "  [0] Instalar seleccionados"
        echo "  [Q] Salir sin hacer nada"
        echo ""
        
        read -p "Ingresa tu opción: " option
        
        case "$option" in
            [1-9]*)
                option_num=$((option))
                if [[ $option_num -ge 1 && $option_num -le ${#theme_names[@]} ]]; then
                    idx=$((option_num - 1))
                    theme="${theme_names[idx]}"
                    
                    # Toggle
                    if [[ " ${selected[@]} " =~ " ${theme} " ]]; then
                        selected=("${selected[@]/${theme}/}")
                        echo -e "${RED}✗ $theme deseleccionado${NC}"
                    else
                        selected+=("$theme")
                        echo -e "${GREEN}✓ $theme seleccionado${NC}"
                    fi
                elif [[ $option_num -eq $((${#theme_names[@]} + 1)) ]]; then
                    # Instalar todos
                    echo ""
                    echo -e "${YELLOW}Instalando todos los temas...${NC}"
                    echo ""
                    for theme in "${theme_names[@]}"; do
                        run_theme "$theme" || echo -e "${RED}✗ Error al instalar $theme${NC}"
                    done
                    echo ""
                    echo -e "${GREEN}✓ ¡Completado!${NC}"
                    exit 0
                else
                    echo -e "${RED}Opción inválida.${NC}"
                fi
                ;;
            0)
                if [[ ${#selected[@]} -eq 0 ]]; then
                    echo -e "${RED}✗ No hay temas seleccionados${NC}"
                else
                    echo ""
                    echo -e "${YELLOW}Instalando temas seleccionados...${NC}"
                    echo ""
                    for theme in "${selected[@]}"; do
                        run_theme "$theme" || echo -e "${RED}✗ Error al instalar $theme${NC}"
                    done
                    echo ""
                    echo -e "${GREEN}✓ ¡Completado!${NC}"
                    exit 0
                fi
                ;;
            Q|q)
                echo -e "${YELLOW}Cancelado.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opción inválida.${NC}"
                ;;
        esac
        
        echo ""
    done
}

# ==============================================================
# MAIN
# ==============================================================

main() {
    if [[ $# -eq 0 ]]; then
        interactive_menu
        return
    fi
    
    local themes_to_install=()
    local install_all=0
    
    # Parsear argumentos
    for arg in "$@"; do
        case "$arg" in
            --all)
                install_all=1
                ;;
            --list)
                list_themes
                exit 0
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            --kitty|--starship|--nvim|--gnome|--mc)
                theme_name=${arg#--}
                themes_to_install+=("$theme_name")
                ;;
            *)
                echo -e "${RED}Error: Opción desconocida: $arg${NC}"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Si --all, obtener todos los temas
    if [[ $install_all -eq 1 ]]; then
        for theme_script in "$THEMES_DIR"/*.sh; do
            if [[ -f "$theme_script" ]]; then
                theme_name=$(basename "$theme_script" .sh)
                themes_to_install+=("$theme_name")
            fi
        done
    fi
    
    # Instalar temas
    if [[ ${#themes_to_install[@]} -eq 0 ]]; then
        echo -e "${RED}Error: No hay temas para instalar${NC}"
        show_usage
        exit 1
    fi
    
    echo -e "${YELLOW}Instalando temas...${NC}"
    echo ""
    
    for theme in "${themes_to_install[@]}"; do
        run_theme "$theme" || echo -e "${RED}✗ Error al instalar $theme${NC}"
    done
    
    echo ""
    echo -e "${GREEN}✓ ¡Completado!${NC}"
}

main "$@"
