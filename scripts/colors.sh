#!/usr/bin/env bash
# Instalador de tema de colores personalizado para varios programas
# Ejecuta los scripts individuales de cada tema

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROGRAMS_DIR="$SCRIPT_DIR/colors"

export SCRIPT_DIR

# =========================================================
# FUNCIONES
# =========================================================

# === Header ===
show_header() {
    echo "========================================"
    echo "    Instalador de Tema Personalizado"
    echo "========================================"
    echo ""
}

# === Help ===
show_usage() {
    cat << HELP
Uso: $(basename "$0") [OPCIONES]

OPCIONES:
  --all              Instalar para todos los programas disponibles
  --<programa>       Instalar para un programa específico
  --list             Listar programas disponibles
  -h, --help         Mostrar esta ayuda
HELP
}

# === Finalizar instalación ===
finish_installation() {
    echo ""
    echo "========================================"
    echo "        Instalación finalizada"
    echo "========================================"
}

# === Listar programas ===
list_programs() {
    local program_name
    local program_script
    echo "Programas disponibles:"
    echo ""
    for program_script in "$PROGRAMS_DIR"/*.sh; do
        if [[ -f "$program_script" ]]; then
            program_name=$(basename "$program_script" .sh)
            echo "  • $program_name"
        fi
    done
}

# === Ejecuta programa específico ===
run_program() {
    local program_name=$1
    local program_script="$PROGRAMS_DIR/$program_name.sh"
    
    if [[ ! -f "$program_script" ]]; then
        echo -e "Programa no encontrado: $program_name"
        return 1
    fi
    
    if [[ ! -x "$program_script" ]]; then
        chmod +x "$program_script"
    fi
    
    if [[ "$EUID" -ne 0 ]] && head -5 "$program_script" | grep -q "# REQUIERE_SUDO"; then
        sudo "$program_script"
    else
        "$program_script"
    fi
}

# === Menú interactivo ===
interactive_menu() {
    declare -a selected=()
    declare -a program_names=()
    local program_script
    local program_name program_names
    local i
    local idx
    local program
    local option
    local option_num
    local new_selected
    local item
    local error_msg=""

    for program_script in "$PROGRAMS_DIR"/*.sh; do
        if [[ -f "$program_script" ]]; then
            program_name=$(basename "$program_script" .sh)
            program_names+=("$program_name")
        fi
    done
    
    while true; do
        clear
        show_header

        if [[ -n "$error_msg" ]]; then
            echo "$error_msg"
            echo ""
            error_msg=""
        fi

        echo "Selecciona para qué programas instalar:"
        echo ""
        
        for i in "${!program_names[@]}"; do
            idx=$((i + 1))
            program="${program_names[i]}"

            if [[ " ${selected[@]} " =~ " ${program} " ]]; then
                echo "  [✓] [$idx] $program"
            else
                echo "  [ ] [$idx] $program"
            fi
        done
        
        echo ""
        echo "  [$((${#program_names[@]} + 1))] Instalar todos"
        echo "  [0] Instalar seleccionados"
        echo "  [Q] Salir sin instalar"
        echo ""
        
        read -p "Ingresa tu opción: " option
        echo ""
        
        case "$option" in
            [1-9]*)
                option_num=$((option))
                if [[ $option_num -ge 1 && $option_num -le ${#program_names[@]} ]]; then
                    idx=$((option_num - 1))
                    program="${program_names[idx]}"

                    if [[ " ${selected[@]} " =~ " ${program} " ]]; then
                        new_selected=()
                        for item in "${selected[@]}"; do
                            [[ "$item" != "$program" ]] && new_selected+=("$item")
                        done
                        selected=("${new_selected[@]}")
                    else
                        selected+=("$program")
                    fi

                elif [[ $option_num -eq $((${#program_names[@]} + 1)) ]]; then
                    echo "========================================"
                    echo ""
                    echo " Instalando todos los programas..."
                    echo ""
                    for program in "${program_names[@]}"; do
                        run_program "$program" || echo "Error al instalar $program"
                    done
                    finish_installation
                    exit 0
                else
                    error_msg="Opción inválida: $option"
                fi
                ;;
            0)
                if [[ ${#selected[@]} -eq 0 ]]; then
                    error_msg="No hay programas seleccionados"
                else
                    echo "========================================"
                    echo ""
                    echo " Instalando programas seleccionados..."
                    echo ""
                    for program in "${selected[@]}"; do
                        run_program "$program" || echo "Error al instalar $program"
                    done
                    finish_installation
                    exit 0
                fi
                ;;
            Q|q)
                echo "========================================"
                echo "         Instalación cancelada"
                echo "========================================"
                exit 0
                ;;
            *)
                error_msg="Opción inválida: $option"
                ;;
        esac
    done
}

# =========================================================
# MAIN
# =========================================================

main() {
    local programs_to_install=()
    local install_all=0
    local arg
    local program_name
    local program_script
    local program
    
    if [[ $# -eq 0 ]]; then
        interactive_menu
        return
    fi

    for arg in "$@"; do
        case "$arg" in
            --all)
                install_all=1
                ;;
            --list)
                list_programs
                exit 0
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            --*)
                program_name=${arg#--}
                programs_to_install+=("$program_name")
                ;;
            *)
                echo "Error: Opción desconocida: $arg"
                show_usage
                exit 1
                ;;
        esac
    done

    if [[ $install_all -eq 1 ]]; then
        for program_script in "$PROGRAMS_DIR"/*.sh; do
            if [[ -f "$program_script" ]]; then
                program_name=$(basename "$program_script" .sh)
                programs_to_install+=("$program_name")
            fi
        done
    fi
    
    if [[ ${#programs_to_install[@]} -eq 0 ]]; then
        echo "No hay programas para instalar"
        show_usage
        exit 1
    fi
    echo ""
    echo "Instalando programas..."
    echo ""
    
    for program in "${programs_to_install[@]}"; do
        run_program "$program" || echo "Error al instalar $program"
    done
    echo ""
    echo "Instalación finalizada"
}

main "$@"
