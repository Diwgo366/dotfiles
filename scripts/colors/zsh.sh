#!/usr/bin/env bash
# Tema de colores para impresiones en zsh

set -euo pipefail
SCRIPT_ZSH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_ZSH/common.sh"

hex_to_ansi() {
    local hex=$1
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    printf "\$'\\\\033[38;2;%d;%d;%dm'" "$r" "$g" "$b"
}

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando en Zsh..."
    
    ZSH_COLORS="$DOTFILES_DIR/zsh/.zsh.d/00-colors.zsh"
    mkdir -p "$(dirname "$ZSH_COLORS")"
    
    {
        echo "# =============================================================="
        echo "# Colores generados automaticamente"
        echo "# =============================================================="
        echo ""
        echo "# Foreground"
        echo "export CL_FOREGROUND=$(hex_to_ansi "$FOREGROUND")  # $FOREGROUND"
        echo ""
        echo "# Background"
        echo "export CL_BACKGROUND=$(hex_to_ansi "$BACKGROUND")  # $BACKGROUND"
        echo ""
        echo "# Current line"
        echo "export CL_CURRENT_LINE=$(hex_to_ansi "$CURRENT_LINE")  # $CURRENT_LINE"
        echo ""
        echo "# Comment"
        echo "export CL_COMMENT=$(hex_to_ansi "$COMMENT")  # $COMMENT"
        echo ""
        echo "# Colores principales"
        echo "export CL_ROJO=$(hex_to_ansi "$COLOR1")     # $COLOR1"
        echo "export CL_VERDE=$(hex_to_ansi "$COLOR2")    # $COLOR2"
        echo "export CL_AMARILLO=$(hex_to_ansi "$COLOR3") # $COLOR3"
        echo "export CL_MORADO=$(hex_to_ansi "$COLOR4")   # $COLOR4"
        echo "export CL_ROSA=$(hex_to_ansi "$COLOR5")     # $COLOR5"
        echo "export CL_CYAN=$(hex_to_ansi "$COLOR6")     # $COLOR6"
        echo "export CL_NARANJA=$(hex_to_ansi "$COLOR7")  # $COLOR7"
        echo ""
        echo "# Colores brillantes"
        echo "export CL_GRIS=$(hex_to_ansi "$COLOR8")         # $COLOR8"
        echo "export CL_ROJO_BRIGHT=$(hex_to_ansi "$COLOR9")  # $COLOR9"
        echo "export CL_VERDE_BRIGHT=$(hex_to_ansi "$COLOR10") # $COLOR10"
        echo "export CL_AMARILLO_BRIGHT=$(hex_to_ansi "$COLOR11") # $COLOR11"
        echo "export CL_MORADO_BRIGHT=$(hex_to_ansi "$COLOR12") # $COLOR12"
        echo "export CL_ROSA_BRIGHT=$(hex_to_ansi "$COLOR13")  # $COLOR13"
        echo "export CL_CYAN_BRIGHT=$(hex_to_ansi "$COLOR14")  # $COLOR14"
        echo "export CL_NARANJA_BRIGHT=$(hex_to_ansi "$COLOR15") # $COLOR15"
        echo ""
        echo "# Reset"
        echo "export CL_RESET=$(hex_to_ansi "$FOREGROUND")"
    } > "$ZSH_COLORS"
    
    echo "Zsh instalado"
}

main "$@"