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
