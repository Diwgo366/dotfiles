#!/bin/bash

WOFI_CSS="/home/diego/Dotfiles/.config/wofi/style.css"

BG_COLOR="#282a36"
AC_COLOR="#262626"

# Extraer valores via hyprctl getoption
ACTIVE_RAW=$(hyprctl getoption general:col.active_border -j | jq -r '.gradient' | cut -d' ' -f1)
INACTIVE_RAW=$(hyprctl getoption general:col.inactive_border -j | jq -r '.gradient' | cut -d' ' -f1)
ROUNDING=$(hyprctl getoption decoration:rounding -j | jq -r '.int // 10')
BORDER_SIZE=$(hyprctl getoption general:border_size -j | jq -r '.int // 2')

# Convertir colores de AARRGGBB a #RRGGBB
ACTIVE_HEX="#${ACTIVE_RAW:2}"
INACTIVE_HEX="#${INACTIVE_RAW:2}"

# Generar CSS
cat > "$WOFI_CSS" <<EOF
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
    border-radius: ${ROUNDING}px;
}

#input {
    margin: 25px;
	margin-bottom: 0px;
    border: ${BORDER_SIZE}px solid ${INACTIVE_HEX};
    padding: 5px;
    border-radius: ${ROUNDING}px;
    background-color: ${BG_COLOR};
    color: ${INACTIVE_HEX};
}

#input image {
    border: none;
    padding: 6px;
    padding-right: 15px;
    color: ${INACTIVE_HEX};
}

#input:focus image {
    color: ${ACTIVE_HEX};
}

#input:focus {
    border: ${BORDER_SIZE}px solid ${ACTIVE_HEX};
	background-color: alpha(${AC_COLOR}, 0.5);
    color: ${ACTIVE_HEX};
	box-shadow: none;
}

#inner-box {
    padding: 20px;
	padding-top: 10px;
}

#outer-box {
    padding: 0px;
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
    color: ${ACTIVE_HEX};
    background-color: transparent;
}

#entry:selected {
    border: ${BORDER_SIZE}px solid ${ACTIVE_HEX};
	background-color: alpha(${AC_COLOR}, 0.5);
    color: ${ACTIVE_HEX};
	box-shadow: inset 0 0 ${ROUNDING}px 0px alpha(${AC_COLOR},1) ;
}

EOF
