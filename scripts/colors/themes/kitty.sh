#!/usr/bin/env bash
# Tema de colores para Kitty

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando tema Kitty..."
    
    OUTPUT_FILE="$DOTFILES_DIR/kitty/.config/kitty/colors.conf"
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    {
        echo "# =============================================================="
        echo "# Colores generados por colors/themes/kitty.sh"
        echo "# =============================================================="
        echo ""
        echo "background $BACKGROUND"
        echo "foreground $FOREGROUND"
        echo "selection_background $CURRENT_LINE"
        echo "selection_foreground $FOREGROUND"
        echo "url_color $COMMENT"
        echo "cursor $FOREGROUND"
        echo "cursor_text_color $BACKGROUND"
        echo ""
        for i in {0..15}; do
            var="COLOR$i"
            echo "color$i ${!var}"
        done
        echo ""
        echo "active_border_color $COLOR4"
        echo "tab_bar_background $BACKGROUND"
        echo "tab_bar_margin_color $CURRENT_LINE"
        echo "active_tab_foreground $BACKGROUND"
        echo "active_tab_background $COLOR4"
        echo "inactive_tab_foreground $COMMENT"
        echo "inactive_tab_background $CURRENT_LINE"
    } > "$OUTPUT_FILE"
    
    echo "Tema Kitty instalado"
}

main "$@"
