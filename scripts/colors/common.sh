#!/usr/bin/env bash
# Funciones comunes para todos los temas de colores

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
COLORS_JSON="$DOTFILES_DIR/colors/colors.json"

# ==============================================================
# VALIDACIÓN Y EXTRACCIÓN
# ==============================================================

validate_colors_json() {
    if [[ ! -f "$COLORS_JSON" ]]; then
        echo "Error: $COLORS_JSON not found"
        exit 1
    fi
}

# Extrae los colores del JSON y los exporta como variables
extract_colors() {
    export COLORS_JSON
    eval "$(python3 << PYEOF
import json, os

with open(os.environ['COLORS_JSON']) as f:
    data = json.load(f)

out = []
for key, val in data.get('structural', {}).items():
    out.append(f'{key.upper()}={val!r}')

for key, val in data.get('ansi', {}).items():
    out.append(f'{key.upper()}={val!r}')

print('; '.join(out))
PYEOF
    )"
}

# Obtiene el nombre de la paleta desde el JSON
get_palette_name() {
    python3 << EOF
import json, os
with open(os.environ['COLORS_JSON']) as f:
    data = json.load(f)
print(data.get("name", "custom_dotfiles"))
EOF
}

export -f validate_colors_json
export -f extract_colors
export -f get_palette_name
export DOTFILES_DIR
export COLORS_JSON
