# ==============================================================
# FUNCTIONS - Funciones personalizadas
# ==============================================================

# === Gatos ASCII ===
cat1() {
  cat << "EOF"
    ,-.       _,---._ __  / \
   /  )    .-'       `./ /   \
  (  (   ,'            `/    /|
   \  `-"             \'\   / |
    `.              ,  \ \ /  |
     /`.          ,'-`----Y   |
    (            ;        |   '
    |  ,-.    ,-'         |  /
    |  | (   |            | /
    )  |  \  `.___________|/
    `--'   `--'
EOF
}

cat2() {
  cat << "EOF"
        _
        \`*-.
         )  _`-.
        .  : `. .
        : _   '  \
        ; *` _.   `*-._
        `-.-'          `-.
          ;       `       `.
          :.       .        \
          . \  .   :   .-'   .
          '  `+.;  ;  '      :
          :   '  |    ;       ;-.
    .-.   ;  '   : :`-:     _.`* ;
   |   |.*' /  .*' ; .*`- +'  `*'
    °-° '*-*   `*-*  `*-*'

EOF
}

# === Utilidades ===
# Crear un directorio y acceder a él
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Descargar archivo con curl y mostrar progreso
download() {
    curl -# -O "$1"
}

pdfview() {
  if [[ $# -eq 0 || ! -f "$1" ]]; then
    echo "Uso: pdfview <archivo.pdf>"
    return 1
  fi

  command -v pdftoppm &>/dev/null || { echo "Error: pdftoppm no encontrado."; return 1; }
  command -v kitty &>/dev/null || { echo "Error: kitty no encontrado."; return 1; }

  local total=$(pdfinfo "$1" 2>/dev/null | awk '/^Pages:/{print $2}')
  total=${total:-1}

  local p=1 tmpdir="/tmp/pdfview_$$"
  mkdir -p "$tmpdir"
  trap "rm -rf $tmpdir" EXIT

  # Array de modos de ajuste
  local -a fit_modes=(both width height none)
  local -a fit_labels=("↔↕" "↔" "↕" "□")
  local fit_idx=1

  while true; do
    local imgfile="$tmpdir/page-${p}.png"
    
    # Generar PNG solo si no existe
    if [[ ! -f "$imgfile" ]]; then
      pdftoppm -png -f "$p" -l "$p" "$1" "$tmpdir/page" 2>/dev/null
      if [[ ! -f "$imgfile" ]]; then
        echo "Error al procesar página $p"
        return 1
      fi
    fi

    # Mostrar imagen con kitty
    if [[ "${fit_modes[$fit_idx]}" == "none" ]]; then
      kitty +kitten icat "$imgfile" < /dev/null
    else
      kitty +kitten icat --fit "${fit_modes[$fit_idx]}" "$imgfile" < /dev/null
    fi

    # Prompt
    printf "\nPágina %d/%d [%s] — n:sig  p:ant  f:fit  q:salir: " "$p" "$total" "${fit_labels[$fit_idx]}"
    
    # Leer una tecla (zsh nativo)
    read -k key
    printf "\n"
    
    # Procesar entrada
    case "$key" in
      n)
        if [[ $p -lt $total ]]; then
          ((p++))
        fi
        ;;
      p)
        if [[ $p -gt 1 ]]; then
          ((p--))
        fi
        ;;
      f)
        fit_idx=$(( fit_idx % 4 + 1 ))
        ;;
      q)
        break
        ;;
    esac
  done
}


