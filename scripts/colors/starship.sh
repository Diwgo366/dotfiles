#!/usr/bin/env bash
# Tema de colores para Starship

set -euo pipefail

SCRIPT_STAR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_STAR/common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando en Starship..."
    
    STARSHIP_TOML="$DOTFILES_DIR/starship/.config/starship.toml"
    mkdir -p "$(dirname "$STARSHIP_TOML")"
    touch "$STARSHIP_TOML"
    
    PALETTE_NAME=$(get_palette_name)
    
    NEW_SECTION="# =========================================================
# Colores generados automaticamente
# =========================================================
[palettes.${PALETTE_NAME}]
purple = \"${COLOR4}\"
pink   = \"${COLOR13}\"
orange = \"${COLOR7}\"
cyan   = \"${COLOR14}\"
green  = \"${COLOR2}\"
red    = \"${COLOR1}\"
yellow = \"${COLOR11}\"
blue   = \"${COLOR6}\"
magenta = \"${COLOR5}\"
white  = \"${FOREGROUND}\"
black  = \"${COLOR0}\""
    
    HEADER="[palettes.${PALETTE_NAME}]"
    export NEW_SECTION HEADER PALETTE_NAME
    
    awk '
    $0 == ENVIRON["HEADER"] { flag = 1; next }
    flag && /^\[/           { flag = 0 }
    flag                    { next }
    {
        if (/^[ \t]*palette[ \t]*=/) {
            if (!replaced) {
                print "palette = '\''" ENVIRON["PALETTE_NAME"] "'\''"
                replaced = 1
            }
            next
        }
        print
    }
    ' "$STARSHIP_TOML" > "${STARSHIP_TOML}.tmp"
    
    if grep -q "^palette = " "${STARSHIP_TOML}.tmp" 2>/dev/null; then
        mv "${STARSHIP_TOML}.tmp" "$STARSHIP_TOML"
    else
        { echo "palette = '$PALETTE_NAME'"; echo ""; cat "${STARSHIP_TOML}.tmp"; } > "$STARSHIP_TOML"
    fi
    
    echo "" >> "$STARSHIP_TOML"
    echo "$NEW_SECTION" >> "$STARSHIP_TOML"
    
    echo "Starship instalado"
}

main "$@"
