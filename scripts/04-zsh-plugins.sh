#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    if [[ -n ${SUDO_USER:-} && ${SUDO_USER:-} != root ]]; then
        script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
        exec sudo -u "$SUDO_USER" -H bash "$script_path" "$@"
    fi
    echo "No ejecutes este script como root: los plugins deben instalarse en el HOME del usuario." >&2
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "Falta el comando requerido: git" >&2
    exit 1
fi

plugins_dir="${ZSH_PLUGINS_DIR:-$HOME/.zsh/plugins}"
mkdir -p "$plugins_dir"

plugins=(
    "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions.git|zsh-autosuggestions.zsh"
    "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting.git|zsh-syntax-highlighting.zsh"
    "zsh-history-substring-search|https://github.com/zsh-users/zsh-history-substring-search.git|zsh-history-substring-search.zsh"
)

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

for entry in "${plugins[@]}"; do
    IFS='|' read -r plugin_name plugin_url plugin_file <<< "$entry"
    plugin_path="$plugins_dir/$plugin_name"

    if [[ -f "$plugin_path/$plugin_file" ]]; then
        echo "==> $plugin_name ya está instalado."
        continue
    fi

    if [[ -e "$plugin_path" || -L "$plugin_path" ]]; then
        echo "La ruta $plugin_path existe pero no contiene $plugin_file." >&2
        echo "Muévela o elimínala y vuelve a ejecutar el instalador." >&2
        exit 1
    fi

    echo "==> Instalando $plugin_name..."
    git clone --depth 1 "$plugin_url" "$tmp_dir/$plugin_name"

    if [[ ! -f "$tmp_dir/$plugin_name/$plugin_file" ]]; then
        echo "El repositorio $plugin_name no contiene $plugin_file." >&2
        exit 1
    fi

    mv -- "$tmp_dir/$plugin_name" "$plugin_path"
done

echo "Extensiones de zsh instaladas en $plugins_dir."
