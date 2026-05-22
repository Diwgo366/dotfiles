#!/usr/bin/env bash
# Funciones comunes para todos los temas de colores

set -euo pipefail

DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COLORS_JSON="$SCRIPT_DIR/colors/colors.json"

export DOTFILES_DIR
export COLORS_JSON

# =========================================================
# FUNCIONES
# =========================================================

validate_colors_json() {
    if [[ ! -f "$COLORS_JSON" ]]; then
        echo "No se encontró: $COLORS_JSON"
        exit 1
    fi
}

# === Extraer colores del JSON ===
extract_colors() {
    export COLORS_JSON
    eval "$(python3 << PYEOF
import json, os

with open(os.environ['COLORS_JSON']) as f:
    data = json.load(f)

out = []
for key, val in data.get('structural', {}).items():
    out.append(f'{key.upper()}={val!r}')

for key, val in data.get('palette', {}).items():
    out.append(f'{key.upper()}={val!r}')

print('; '.join(out))
PYEOF
    )"
}

# === Extraer nombre de la paleta ===
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
