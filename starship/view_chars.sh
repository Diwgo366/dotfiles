#!/bin/bash

# Script para visualizar caracteres de Nerd Font en CaskayDiamono
# Uso: ./view_chars.sh [categoría]

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         VISUALIZADOR DE CARACTERES - CASKAYDIA NERD FONT       ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

if [ -z "$1" ]; then
  echo "Categorías disponibles:"
  echo ""
  echo "  1 - Flechas"
  echo "  2 - Círculos y puntos"
  echo "  3 - Cuadrados"
  echo "  4 - Triángulos"
  echo "  5 - Separadores"
  echo "  6 - Símbolos de estado"
  echo "  7 - Diamantes"
  echo "  8 - Líneas y bordes"
  echo ""
  echo "Uso: $0 [número]"
  echo "Ejemplo: $0 1  (para ver todas las flechas)"
  exit 0
fi

case $1 in
  1|flechas)
    echo "FLECHAS Y DIRECCIONALES:"
    echo "← → ↑ ↓ ↔ ↕ ↖ ↗ ↘ ↙ ↚ ↛ ↜ ↝ ↞ ↟ ↠ ↡ ↢ ↣ ↤ ↥ ↦ ↧ ↨ ↩ ↪ ↫ ↬ ↭ ↮ ↯"
    echo "↰ ↱ ↲ ↳ ↴ ↵ ↶ ↷ ↸ ↹ ↺ ↻ ⇀ ⇁ ⇂ ⇃ ⇄ ⇅ ⇆ ⇇ ⇈ ⇉ ⇊ ⇋ ⇌ ⇍ ⇎ ⇏ ⇐ ⇑"
    echo "⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛ ⇜ ⇝ ⇞ ⇟ ⇠ ⇡ ⇢ ⇣ ⇤ ⇥ ⇦ ⇧ ⇨ ⇩ ⇪ ⇫ ⇬ ⇭ ⇮ ⇯"
    echo ""
    echo "Recomendadas para prompt:"
    echo "  ➜ ❯ ▶ ➤ ➧ ⟶ ⟹"
    ;;
  2|circulos)
    echo "CÍRCULOS Y PUNTOS:"
    echo "● ○ ◑ ◐ ◒ ◓ ◔ ◕ ◘ ◙ ◚ ◛ ◜ ◝ ◞ ◟ ◠ ◡ ◢ ◣ ◤ ◥ ◆ ◇ ◈ ◉ ◎ ◍ ◎ ◌"
    echo "◦ ◯ ⊙ ⊚ ⊕ ⊖ ⊗ ⊘ ⊛ ⊜ ⊝ ⊞ ⊟ ⊠ ⊡ ⊙"
    echo "• ‣ ⁌ ⁍ ⁎ ⁏ ◥ ◤ ◣ ◢ ◬ ◭ ◮ ◪ ◩ ◨ ◧ ◦"
    echo ""
    echo "Recomendadas para git status:"
    echo "  ◉ (modificado) | ◆ (staged) | ⊙ (deletado) | ◇ (untracked) | ◎ (stashed)"
    ;;
  3|cuadrados)
    echo "CUADRADOS Y RECTÁNGULOS:"
    echo "■ □ ◼ ◻ ◽ ◾ ▪ ▫ ▬ ▭ ▮ ▯ ◐ ◑ ◒ ◓ ▢ ▣ ▤ ▥ ▦ ▧ ▨ ▩ ▪ ▫ ▲ ▴ ▶ ▷ ▸ ▹"
    echo "► ▻ ▼ ▽ ◀ ◁ ◂ ◃ ◄ ◅ ◆ ◇ ◈ ◉ ◊ ○ ◍ ◎ ●"
    ;;
  4|triangulos)
    echo "TRIÁNGULOS:"
    echo "▲ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ▼ ▽ ▾ ▿ ◀ ◁ ◂ ◃ ◄ ◅ △ ▲ ▴ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ◀ ◁ ◂ ◃ ◄ ◅"
    echo "◆ ◇ ◈ ◉ ◊ ○ ◍ ◎ ● ◌ ◍ ◎ ◐ ◑ ◒ ◓"
    ;;
  5|separadores)
    echo "SEPARADORES Y LÍNEAS:"
    echo "│ ║ ▌ ▐ ┃ ╎ ╏ ┊ ┋ ═ ─ ━"
    echo ""
    echo "Más opciones:"
    echo "├ ┤ ┬ ┴ ┼ ╠ ╣ ╦ ╩ ╬"
    echo ""
    echo "Degradado: ░ ▒ ▓ █"
    echo ""
    echo "Recomendadas para prompt:"
    echo "  ◈ │ ║ ▌ ▐ • · ⊙"
    ;;
  6|estado)
    echo "SÍMBOLOS DE ESTADO:"
    echo "✓ ✔ ✕ ✖ ✗ ✘ ✙ ✚ ✛ ✜ ✝ ✞ ✟ ✠ ⚠ ⚡"
    echo "☐ ☑ ☒ ☓"
    echo ""
    echo "Recomendadas para git:"
    echo "  ✓ (ok) | ✔ (completado) | ✕ (conflicto) | ✖ (error) | ✘ (deletado)"
    ;;
  7|diamantes)
    echo "DIAMANTES Y FORMAS:"
    echo "◆ ◇ ◈ ◉ ◊ ● ○ ⬟ ⬠ ⬢ ⬡ ⬣ ⬤ ⬥ ⬦ ⬧ ⬨ ⬩ ⬪ ⬫ ⬬ ⬭ ⬮ ⬯"
    echo "❖ ❘ ❙ ❚ ❝ ❞ ❟ ❠"
    echo ""
    echo "Recomendadas para separadores:"
    echo "  ◈ ◉ ◊ ◆ ◇"
    ;;
  8|bordes)
    echo "LÍNEAS Y BORDES:"
    echo "─ ━ │ ┃ ┄ ┅ ┆ ┇ ┈ ┉ ┊ ┋"
    echo "┌ ┐ └ ┘ ├ ┤ ┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻"
    echo "┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋"
    echo "═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝"
    echo "╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬"
    ;;
  *)
    echo "Categoría no reconocida. Usa: $0 [1-8]"
    ;;
esac

echo ""
