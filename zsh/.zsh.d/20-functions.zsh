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

  if [[ "$TERM" != *kitty* ]] || [[ ! -t 0 ]]; then
    if command -v evince &>/dev/null; then
      evince "$1"
    elif command -v okular &>/dev/null; then
      okular "$1"
    else
      echo "No hay un visor PDF disponible. Instalá evince u okular."
      return 1
    fi
    return
  fi

  local p=1
  while :; do
    clear
    if ! pdftoppm -png -f "$p" -l "$p" "$1" /tmp/pdfpic 2>/dev/null; then
      echo "Error al procesar el PDF"
      return 1
    fi
    kitty +kitten icat "/tmp/pdfpic-$p.png" 2>/dev/null
    rm -f /tmp/pdfpic-*.png
    echo "Página $p | n:sig p:ant q:salir"
    read -k1 k
    [[ $k == n ]] && ((p++))
    [[ $k == p && p -gt 1 ]] && ((p--))
    [[ $k == q ]] && break
  done
}

