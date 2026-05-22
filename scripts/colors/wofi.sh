#!/usr/bin/env bash
# Tema de colores para Wofi

set -euo pipefail

SCRIPT_WOFI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_WOFI/common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando en Wofi..."
    
    WOFI_STYLE="$DOTFILES_DIR/wofi/.cache/wal/colors"
    mkdir -p "$(dirname "$WOFI_STYLE")"
    
    {
        echo "$BACKGROUND"
        echo "$CURRENT_LINE"
        echo "$FOREGROUND"
        echo "$COMMENT"
        echo "$COLOR0"
        echo "$COLOR8"
        
    } > "$WOFI_STYLE"
    
    echo "Wofi instalado"
}

main "$@"