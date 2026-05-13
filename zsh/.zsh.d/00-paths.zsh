# ==============================================================
# CONFIGURACIÓN DE PATHS Y VARIABLES DE ENTORNO
# ==============================================================
#
# Este archivo contiene todas las configuraciones de PATH y variables de entorno

# El sistema verificará automáticamente si existen antes de usarlas

# Directorios bin personales del usuario
[[ -d "$HOME/bin" ]]          && path=("$HOME/bin" $path)
[[ -d "$HOME/.local/bin" ]]   && path=("$HOME/.local/bin" $path)

# OpenCode CLI
[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)

# Spicetify (CLI de Spotify)
[[ -d "$HOME/.spicetify" ]]   && path=("$HOME/.spicetify" $path)

# SAC (Código de Análisis Sísmico)
if [[ -d "$HOME/sismica/sac/bin" ]]; then
    path=("$HOME/sismica/sac/bin" $path)
    export SACAUX="$HOME/sismica/sac/aux"
fi

# Integración dinámica de herramientas en ~/.ter-tools
TOOLS_DIR="$HOME/.ter-tools"
if [[ -d "$TOOLS_DIR" ]]; then
    # Exportar cada subdirectorio de .ter-tools al PATH
    for dir in "$TOOLS_DIR"/*/; do
        [[ -d "$dir" ]] && path=("$dir" $path)
    done
    
    # Cargar scripts de shell automáticamente
    for script in "$TOOLS_DIR"/**/*.sh; do
        [[ -f "$script" && -r "$script" ]] && . "$script"
    done
fi

# Exportar el PATH final para que todo el sistema lo reconozca
export PATH
