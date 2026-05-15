# ===============================================================
# CONFIGURACIÓN DE ZSH - ARCHIVO PRINCIPAL
# ===============================================================
# ESTRUCTURA MODULAR:
# - 00-colors.zsh: Definición de colores
# - 10-aliases.zsh: Alias y atajos de comandos
# - 20-functions.zsh: Funciones personalizadas
# - 30-paths.zsh: Variables de entorno y PATHs
# - 40-plugins.zsh: Configuraciones de plugins
# - 50-zsh-config.zsh: Configuraciones específicas de zsh
# ===============================================================

# ===============================================================
# CARGAR MÓDULOS PERSONALIZADOS
# ===============================================================

# Cargar configuraciones modulares desde ~/.zsh.d/
if [[ -d "$HOME/.zsh.d" ]]; then
    for rcfile in "$HOME/.zsh.d"/*.zsh; do
        [[ -r "$rcfile" ]] && . "$rcfile"
    done
fi

# Inicializar Starship prompt
eval "$(~/.local/bin/starship init zsh)"

# ===============================================================
# MENSAJE DE BIENVENIDA
# ===============================================================

# Mostrar mensaje solo en shells interactivos
if [[ $- == *i* ]]; then
    WIDTH=56

    _center() {
        local text="$1"
        local chars=$#text wide=0 i char
        for ((i=1; i<=chars; i++)); do
            char=$text[i]
            (( $(( #char )) > 0xFFFF )) && wide=$(( wide + 1 ))
        done
        local visual=$(( chars + wide ))
        local left=$(( (WIDTH - visual) / 2 ))
        local right=$(( WIDTH - visual - left ))
        (( left < 0 )) && left=0
        (( right < 0 )) && right=0
        printf "%*s%s%*s" "$left" "" "$text" "$right" ""
    }

    _show_welcome() {
        local hour=$(date +%H) greeting icon
        if (( hour < 7 )); then
            greeting="Buenas noches"; icon="🌙"
        elif (( hour < 12 )); then
            greeting="Buenos días"; icon="🌅"
        elif (( hour < 18 )); then
            greeting="Buenas tardes"; icon="☀️"
        else
            greeting="Buenas noches"; icon="🌙"
        fi
        local border="╔$(printf '═%.0s' $(seq 1 $WIDTH))╗"
        echo "$border"
        echo "║$(_center "$icon $greeting, $(whoami)")║"
        echo "║$(_center "Sistema: $(uname -s) ║ Terminal: zsh")║"
        echo "╚${border:1:$WIDTH}╝"
    }

    _show_welcome
    unset -f _show_welcome _center
    unset WIDTH
fi
