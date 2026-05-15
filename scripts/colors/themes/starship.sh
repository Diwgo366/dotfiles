#!/usr/bin/env bash
# Tema de colores para Starship

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando tema Starship..."
    
    STARSHIP_TOML="$DOTFILES_DIR/starship/.config/starship.toml"
    mkdir -p "$(dirname "$STARSHIP_TOML")"
    
    python3 << EOF
import json, re, os

with open(os.environ['COLORS_JSON']) as f:
    d = json.load(f)

palette_name = d.get("name", "custom_dotfiles")
a = d["ansi"]

aliases = {
    "purple": a["color12"],
    "pink":   a["color13"],
    "orange": a["color15"],
    "cyan":   a["color14"],
    "green":  a["color10"],
    "red":    a["color9"],
    "yellow": a["color11"],
    "blue":   a["color6"],
    "magenta": a["color5"],
    "white":  d["structural"]["foreground"],
    "black":  a["color0"],
}

palette_header = f"[palettes.{palette_name}]"
palette_entries = "\n".join(f'{k} = "{v}"' for k, v in aliases.items())

# Crear el archivo si no existe
if not os.path.exists("$STARSHIP_TOML"):
    with open("$STARSHIP_TOML", "w") as f:
        f.write("")

with open("$STARSHIP_TOML") as f:
    content = f.read()

# Procesar línea por línea para no tocar nada fuera del bloque de paleta
lines = content.split('\n')
in_palette_block = False
found_palette = False
new_lines = []
found_active = False

for line in lines:
    stripped = line.strip()

    # Detectar entrada al bloque de paleta
    if stripped == palette_header:
        in_palette_block = True
        found_palette = True
        new_lines.extend([
            "# ==============================================================",
            "# Colores generados por colors/themes/starship.sh",
            "# ==============================================================",
            palette_header,
            palette_entries,
        ])
        continue

    # Detectar salida del bloque de paleta (otra sección)
    if in_palette_block and re.match(r'^\[', stripped):
        in_palette_block = False
        # No descartamos esta línea, la procesamos normalmente

    # Si estamos dentro del bloque de paleta, saltamos líneas
    if in_palette_block:
        continue

    # Fuera del bloque: buscar y actualizar palette activa
    if re.match(r'^\s*palette\s*=', line) and not found_active:
        new_lines.append(f"palette = '{palette_name}'")
        found_active = True
        continue

    new_lines.append(line)

# Si no se encontró ninguna paleta, agregarla al final
if not found_palette:
    new_lines.extend([
        "",
        "# ==============================================================",
        "# Colores generados por colors/themes/starship.sh",
        "# ==============================================================",
        palette_header,
        palette_entries,
    ])

# Si no se encontró palette activa, insertarla al inicio
if not found_active:
    new_lines.insert(0, f"palette = '{palette_name}'")
    new_lines.insert(1, "")

content = '\n'.join(new_lines)

with open("$STARSHIP_TOML", "w") as f:
    f.write(content)
EOF
    
    echo "Tema Starship instalado"
}

main "$@"
