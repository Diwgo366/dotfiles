#!/usr/bin/env bash
set -euo pipefail

WOFI_CSS="$HOME/.config/wofi/style.css"
mkdir -p "$(dirname "$WOFI_CSS")"

THEME_JSON="$AGS_DIR/src/themes/theme.json"

# Leer la paleta activa del tema de AGS.
BG_COLOR=$(jq -er '.colors.bg' "$THEME_JSON")
BG_ALT_COLOR=$(jq -er '.colors.bgAlt' "$THEME_JSON")
FG_COLOR=$(jq -er '.colors.fg' "$THEME_JSON")
FG_ALT_COLOR=$(jq -er '.colors.fgAlt' "$THEME_JSON")
BD_COLOR=$(jq -er '.colors.bd' "$THEME_JSON")
BD_ALT_COLOR=$(jq -er '.colors.bdAlt' "$THEME_JSON")

# Extraer valores via hyprctl getoption
ROUNDING=$(hyprctl getoption decoration:rounding -j 2>/dev/null | jq -r '.int // 10' 2>/dev/null || printf '10')
BORDER_SIZE=$(hyprctl getoption general:border_size -j 2>/dev/null | jq -r '.int // 2' 2>/dev/null || printf '2')

# Generar CSS
TEMP_CSS=$(mktemp "${WOFI_CSS}.XXXXXX")
trap 'rm -f "$TEMP_CSS"' EXIT
cat > "$TEMP_CSS" <<EOF
* {
    font-family: CaskaydiaMono Nerd Font, monospace;
    padding: 0px;
	margin: 0px;
    font-size: 16px;
    border: none;
    outline: none;
    text-shadow:none;
    background-color:transparent;
}

window { 
    text-shadow:none;
    background-color: ${BG_COLOR};
    border: 0;
	padding: 10px;
    border-radius: ${ROUNDING}px;
}

#input {
    margin: 5px;
	margin-top: 20px;
	margin-bottom: 20px;
    border: ${BORDER_SIZE}px solid ${BD_COLOR};
    padding: 0px;
    border-radius: ${ROUNDING}px;
    background-color: ${BG_COLOR};
    color: ${FG_ALT_COLOR};
}

#input image {
    border: none;
    padding: 10px;
    padding-right: 15px;
    color: ${FG_ALT_COLOR};
}

#input:focus image {
    color: ${FG_COLOR};
}

#input:focus {
    border: ${BORDER_SIZE}px solid ${BD_ALT_COLOR};
	background-color: ${BG_ALT_COLOR};
    color: ${FG_COLOR};
	box-shadow: none;
}

#inner-box {
    padding: 0px;
}

#outer-box {
    padding: 20px;
	padding-top: 10px;
}

#text {
    padding-left: 10px;
    padding-right: 10px;
}

#entry {
    border: ${BORDER_SIZE}px solid transparent;
    margin: 5px;
    padding: 8px;
    border-radius: ${ROUNDING}px;
    transition: all 0.2s ease-in-out;
    color: ${FG_COLOR};
    background-color: transparent;
}

#scroll {
    min-width: 0;
}

#entry:selected {
    border: ${BORDER_SIZE}px solid ${BD_ALT_COLOR};
	background-color: ${BG_ALT_COLOR};
}

EOF
mv "$TEMP_CSS" "$WOFI_CSS"
