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

# Actualizar la hora con café en horarios nocturnos
update_time_with_coffee() {
    local hour=$(date +%H)
    local time=$(date +%H:%M)
    
    # Si es de noche (20:00-23:59 o 00:00-05:59), agregar café
    if (( hour >= 20 || hour < 6 )); then
        export TIME_WITH_COFFEE="$time☕"
    else
        export TIME_WITH_COFFEE="$time"
    fi
}
