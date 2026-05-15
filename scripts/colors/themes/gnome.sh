#!/usr/bin/env bash
# Tema de colores para GNOME Terminal

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando tema GNOME Terminal..."
    
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
    
    if [[ -z "$PROFILE" ]]; then
        echo "No se pudo obtener el perfil de GNOME Terminal"
        exit 1
    fi
    
    BASE="/org/gnome/terminal/legacy/profiles:/:$PROFILE/"
    
    PALETTE="[
'$COLOR0',
'$COLOR1',
'$COLOR2',
'$COLOR3',
'$COLOR4',
'$COLOR5',
'$COLOR6',
'$COLOR7',
'$COLOR8',
'$COLOR9',
'$COLOR10',
'$COLOR11',
'$COLOR12',
'$COLOR13',
'$COLOR14',
'$COLOR15'
]"
    
    gsettings set "org.gnome.Terminal.Legacy.Profile:$BASE" use-theme-colors false
    gsettings set "org.gnome.Terminal.Legacy.Profile:$BASE" background-color "$BACKGROUND"
    gsettings set "org.gnome.Terminal.Legacy.Profile:$BASE" foreground-color "$FOREGROUND"
    gsettings set "org.gnome.Terminal.Legacy.Profile:$BASE" palette "$PALETTE"
    
    echo "Tema GNOME Terminal instalado"
}

main "$@"
