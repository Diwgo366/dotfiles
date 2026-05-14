# ==============================================================
# CONFIGURACIONES ESPECÍFICAS DE ZSH
# ==============================================================

# === Historial ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY           # Append history instead of overwriting
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_IGNORE_DUPS         # Don't record duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Remove old commands when duplicates are added
setopt HIST_FIND_NO_DUPS        # Don't show duplicates when searching history
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates

# === Comportamiento del shell ===
setopt AUTO_CD                  # Automatic directory change
setopt CDABLE_VARS              # Variables can be used for directory navigation
setopt PUSHD_IGNORE_DUPS        # Don't duplicate directories in stack
setopt AUTO_PUSHD               # Automatically push directories to stack

# === Globbing y expansión ===
setopt EXTENDED_GLOB            # Extended pattern matching
setopt GLOB_DOTS                # Include dotfiles in globbing

# === Completado ===
setopt MENU_COMPLETE            # Immediate menu completion
setopt ALWAYS_TO_END            # Move to end of line after completion

# === Corrección ===
setopt CORRECT                  # Spell correction for commands
# setopt CORRECT_ALL            # Spell correction for all arguments (descomenta si lo necesitas)

# ==============================================================
# COLORES PARA LS (Dracula Theme)
# ==============================================================
# Habilitar colores en ls
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Configuración de colores para ls (LS_COLORS)
# Formato: type=color
# Colores: 30=black, 31=red, 32=green, 33=yellow, 34=blue, 35=magenta, 36=cyan, 37=white
# Estilos: bold=1, dim=2, normal=0
export LS_COLORS='di=34:fi=37:ln=36:or=31:ex=32:*.txt=37:*.md=37:*.json=33:*.yml=33:*.yaml=33'

# Alias mejorado para ls con colores (Linux)
alias ls='ls --color=auto'                # Enable colors
alias la='ls -lA --color=auto'            # All files with long format
alias ll='ls -lh --color=auto'            # Long format with human readable sizes
alias ld='ls -ld --color=auto */'         # Only directories
