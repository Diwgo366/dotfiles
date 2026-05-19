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
  local p=1
  while :; do
    clear
    pdftoppm -png -f $p -l $p "$1" /tmp/pdfpic
    kitty +kitten icat "/tmp/pdfpic-$p.png"
    rm -f /tmp/pdfpic-*.png
    echo "Página $p | n:sig p:ant q:salir"
    read -k1 k
    [[ $k == n ]] && ((p++))
    [[ $k == p && p -gt 1 ]] && ((p--))
    [[ $k == q ]] && break
  done
}

