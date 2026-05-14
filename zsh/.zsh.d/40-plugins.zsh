# ==============================================================
# PLUGINS Y HERRAMIENTAS
# ==============================================================

# Directorio de plugins
PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGINS_DIR"

# ==============================================================
# LAZY LOADING - Cargar plugins bajo demanda
# ==============================================================

# Función para instalar plugins si no existen
_ensure_plugin() {
    local plugin_url="$1"
    local plugin_name=$(basename "$plugin_url" .git)
    local plugin_path="$PLUGINS_DIR/$plugin_name"
    
    if [[ ! -d "$plugin_path" ]]; then
        git clone --depth 1 "$plugin_url" "$plugin_path" 2>/dev/null
    fi
    
    echo "$plugin_path"
}

# ==============================================================
# PLUGIN: zsh-autosuggestions
# ==============================================================
AUTOSUGGESTIONS_PATH="$PLUGINS_DIR/zsh-autosuggestions"
[[ -f "$AUTOSUGGESTIONS_PATH/zsh-autosuggestions.zsh" ]] && \
    source "$AUTOSUGGESTIONS_PATH/zsh-autosuggestions.zsh" 2>/dev/null

# ==============================================================
# PLUGIN: zsh-syntax-highlighting
# ==============================================================
SYNTAX_HIGHLIGHTING_PATH="$PLUGINS_DIR/zsh-syntax-highlighting"
[[ -f "$SYNTAX_HIGHLIGHTING_PATH/zsh-syntax-highlighting.zsh" ]] && \
    source "$SYNTAX_HIGHLIGHTING_PATH/zsh-syntax-highlighting.zsh" 2>/dev/null

# ==============================================================
# PLUGIN: zsh-history-substring-search
# ==============================================================
HISTORY_SUBSTRING_SEARCH_PATH="$PLUGINS_DIR/zsh-history-substring-search"
if [[ -f "$HISTORY_SUBSTRING_SEARCH_PATH/zsh-history-substring-search.zsh" ]]; then
    source "$HISTORY_SUBSTRING_SEARCH_PATH/zsh-history-substring-search.zsh" 2>/dev/null
    
    # Bind keys para history-substring-search
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# ==============================================================
# COMPLETACIÓN RÁPIDA (sin compaudit lento)
# ==============================================================

# Desabilitar el chequeo lento de compaudit
skip_global_compinit=1

# Inicializar compinit sin compaudit
autoload -Uz compinit
compinit -C

# ==============================================================
# CONFIGURACIÓN ADICIONAL
# ==============================================================

setopt NO_NOMATCH
setopt PROMPT_SUBST

