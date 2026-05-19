#!/usr/bin/env bash
# Tema de colores para Neovim

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common.sh"

main() {
    validate_colors_json
    extract_colors
    
    echo "Instalando tema Neovim..."
    
    OUTPUT_FILE="$DOTFILES_DIR/nvim/.config/nvim/lua/utils/colors.lua"
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    cat > "$OUTPUT_FILE" << EOF
-- =============================================================
--  Colores generados por colors/themes/nvim.sh
-- =============================================================

local colors = {
  -- Colores base
  bg              = '$BACKGROUND',  -- Fondo principal
  fg              = '$FOREGROUND',  -- Texto principal
  current_line    = '$CURRENT_LINE',  -- Línea actual (más claro que bg)
  selection       = '$CURRENT_LINE',  -- Selección
  comment         = '$COMMENT',  -- Comentarios
  
  -- Colores primarios (ANSI 1-7)
  red             = '$COLOR9',  -- Rojo brillante
  green           = '$COLOR10',  -- Verde brillante
  yellow          = '$COLOR11',  -- Amarillo brillante
  purple          = '$COLOR12',  -- Púrpura brillante
  pink            = '$COLOR13',  -- Rosa brillante
  cyan            = '$COLOR14',  -- Cyan brillante
  orange          = '$COLOR15',  -- Naranja brillante
  
  -- Colores secundarios (ANSI 0-7)
  dark_red        = '$COLOR1',
  dark_green      = '$COLOR2',
  dark_yellow     = '$COLOR3',
  dark_purple     = '$COLOR4',
  dark_pink       = '$COLOR5',
  dark_cyan       = '$COLOR6',
  dark_orange     = '$COLOR7',
  
  -- Colores neutros
  white           = '$FOREGROUND',
  gray            = '$COLOR8',
  dark_gray       = '$CURRENT_LINE',
  light_gray      = '$COMMENT',
  black           = '$COLOR0',
  
  -- Colores semánticos
  error           = '$COLOR9',    -- Rojo
  warning         = '$COLOR11',   -- Amarillo
  success         = '$COLOR10',   -- Verde
  info            = '$COLOR14',   -- Cyan
  hint            = '$COLOR12',   -- Púrpura
  
  -- Para bordes y divisores
  border          = '$CURRENT_LINE',
  fold            = '$COMMENT',
  folded          = '$CURRENT_LINE',
  
  -- Para líneas y números
  line_nr         = '$COMMENT',
  line_nr_bg      = '$BACKGROUND',
  cursor_line_nr  = '$FOREGROUND',
}

return colors
EOF
    
    echo "Tema Neovim instalado"
}

main "$@"
