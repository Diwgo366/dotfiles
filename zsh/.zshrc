# ===============================================================
# CONFIGURACIÓN DE ZSH - ARCHIVO PRINCIPAL
# ===============================================================
# ESTRUCTURA MODULAR:
# - 00-paths.zsh: Variables de entorno y PATHs
# - 10-aliases.zsh: Alias y atajos de comandos
# - 20-functions.zsh: Funciones personalizadas
# - 30-zsh-config.zsh: Configuraciones específicas de zsh
# - 40-ohmyzsh.zsh: Configuraciones específicas de Oh My Zsh
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
    _show_welcome() {
        local hour=$(date +%H)
        local greeting
        local icon
        
        if (( hour < 7 )); then
            greeting="Buenas noches"
            icon="🌙"  # Luna
        elif (( hour < 12 )); then
            greeting="Buenos días"
            icon="🌅"  # Salida del sol
        elif (( hour < 18 )); then
            greeting="Buenas tardes"
            icon="☀️"  # Sol
        else
            greeting="Buenas noches"
            icon="🌙"  # Luna
        fi
        
        echo "╔════════════════════════════════════════════════════════╗"
        echo "║ $icon $greeting, $(whoami)!"
        echo "║ ▸ Sistema: $(uname -s) ║ Terminal: zsh"
        echo "╚════════════════════════════════════════════════════════╝"
    }
    
    _show_welcome
    unset -f _show_welcome
fi
