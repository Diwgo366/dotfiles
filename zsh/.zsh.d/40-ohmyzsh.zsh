# ==============================================================
# OH MY ZSH
# ==============================================================

# Ruta de instalación
export ZSH="$HOME/.oh-my-zsh"

# Verificar instalación
if [[ ! -d "$ZSH" ]]; then
    echo "[ZSH] Oh My Zsh no encontrado en: $ZSH"
    return
fi

# ==============================================================
# TEMA
# ==============================================================

ZSH_THEME="dracula"

# Configuración del tema Dracula
DRACULA_DISPLAY_GIT=1
DRACULA_DISPLAY_TIME=1
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_FULL_CWD=1
DRACULA_DIR_TRIM=1
DRACULA_DISPLAY_NEW_LINE=1

# =============================================================
# PLUGINS
# =============================================================

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
)

# =============================================================
# CARGAR OH MY ZSH
# =============================================================

source "$ZSH/oh-my-zsh.sh"
