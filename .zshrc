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

export TERMINAL=kitty

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
eval "$(starship init zsh)"

# ===============================================================
# MENSAJE DE BIENVENIDA
# ===============================================================

# Mostrar mensaje solo en shells interactivos
if [[ $- == *i* ]]; then

	command -v python3 >/dev/null 2>&1 || return

    _visual_width() {
	python3 - "$1" << 'EOF'
import re, sys, wcwidth

s = sys.argv[1]
s = re.sub(r'\x1b\[[0-9;]*m', '', s)

print(sum(wcwidth.wcwidth(c) for c in s))
EOF
	}

    _show_welcome() {
 
		local hour=$(date +%H)
		local grt_msg grt_ico grt_cl

        if (( hour < 7 )); then
            grt_msg="Buenas noches"
			grt_ico=$'\uf186'
			grt_cl=$CL_MORADO_BRIGHT

        elif (( hour < 12 )); then
            grt_msg=" Buenos días"
			grt_ico=$'\ue342'
			grt_cl=$CL_AMARILLO_BRIGHT

        elif (( hour < 18 )); then
            grt_msg="Buenas tardes"
			grt_ico=$'\uf185'
			grt_cl=$CL_AMARILLO_BRIGHT

        else
            grt_msg="Buenas noches"
			grt_ico=$'\uf186'
			grt_cl=$CL_MORADO_BRIGHT
        fi

		local os_nm=$(uname -s)
        local os_ico
        
		case "$os_nm" in
            Linux)
				os_ico=$'\uf17c'
				;;
            Darwin)
				os_nm="masOS"
				os_ico=$'\uf179'
				;;
            FreeBSD)
				os_nm="FreeBSD"
				os_ico=$'\uf17c'
				;;
            CYGWIN*|MINGW*|MSYS*)
				os_nm="Windows"
				os_ico=$'\uf17a'
				;;
            *)
				os_nm="Unknown"
				os_ico="?"
				;;
        esac

		if [[ "$os_nm" == "Linux" ]]; then
			if [[ -f /etc/os-release ]]; then
				. /etc/os-release
				os_nm="$NAME"
			fi
		fi

		if [[ -n "$SSH_CONNECTION" ]]; then
			con_cl=$CL_ROJO_BRIGHT
			con_ico=$'\uf489'
		else
			con_ico=$'\uf109'
			con_cl=$CL_CYAN_BRIGHT
		fi

		local line1="${grt_cl}${grt_ico} ${grt_msg}${reset}, $CL_VERDE_BRIGHT$(whoami)$CL_RESET"
		local line2="Bienvenido a ${con_cl}${con_ico}  $(hostname)$CL_RESET | $CL_RESET${os_ico} ${os_nm}$CL_RESET"

		local w=${COLUMNS:-$(tput cols)}
		local v1=$(_visual_width "$line1")
        local v2=$(_visual_width "$line2")
        
		local l1=$(( (w - v1) / 2 ))
		local l2=$(( (w - v2) / 2 ))

		if (( l1 < 0 || l2 < 0 )); then
			return 0
		fi
		
		printf '%*s\n' "$w" '' | tr ' ' '='
		printf "%*s%s%*s\n" "$l1" "" "$line1"
        printf "%*s%s%*s\n" "$l2" "" "$line2"
        printf '%*s\n' "$w" '' | tr ' ' '='
    }

    _show_welcome
    unset -f _show_welcome _visual_width
fi


export PATH=$PATH:/home/diego/.spicetify
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
nvm() { unset -f nvm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; nvm "$@"; }
node() { unset -f node; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm() { unset -f npm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx() { unset -f npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }
