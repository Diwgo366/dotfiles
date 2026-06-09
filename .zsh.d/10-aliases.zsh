# ==============================================================
# ALIASES - Atajos y alias útiles
# ==============================================================

# === Kitty Terminal ===
alias icat='kitten icat'

# === Navegación ===
alias ..='cd ..'
alias ...='cd ../..'

# === Listados ===
alias ls='eza --icons'
alias ll='eza -alh --icons --group-directories-first'
alias la='eza -a --icons'
alias l='eza -F --icons'
alias lsd='eza -D --icons'

# === Utilidades ===
alias dact='deactivate'

alias matlab='xhost +SI:localuser:root >/dev/null 2>&1; sudo systemd-nspawn -D /var/lib/machines/debian11 \
  --bind=/home/diego/MATLAB:/usr/local/MATLAB \
  --bind-ro=/tmp/.X11-unix:/tmp/.X11-unix \
  --bind=/home/diego:/home/diego \
  --bind-ro=/etc/passwd \
  --setenv=DISPLAY=${DISPLAY:-:1} \
  --setenv=_JAVA_AWT_WM_NONREPARENTING=1 \
  --as-pid2 /usr/local/MATLAB/R2018a/bin/matlab -softwareopengl'

# === Navegación web ===
alias portal='brave http://neverssl.com >/dev/null 2>&1 &'

# === Git (complementarios) ===
alias gst='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

alias kmusic='kitty --session ~/.config/kitty/sessions/music.conf'
