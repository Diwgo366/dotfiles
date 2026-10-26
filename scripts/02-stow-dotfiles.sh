#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.local/state/dotfiles-stow-backups/$(date +%Y%m%d%H%M%S)-$$"

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow no está instalado. Ejecuta primero 00-packages.sh." >&2
    exit 1
fi

backup_target() {
    local target="$1"
    local relative_path="$2"

    if [[ -e "$target" || -L "$target" ]]; then
        local saved_path="$BACKUP_DIR/$relative_path"
        mkdir -p "$(dirname "$saved_path")"
        mv -- "$target" "$saved_path"
        echo "Respaldo: $target -> $saved_path"
    fi
}

echo "==> Retirando enlaces de Stow de la estructura anterior..."
stow -D -d "$DOTFILES/.config" -t "$HOME/.config" . 2>/dev/null || true
stow -D -d "$DOTFILES" -t "$HOME" .zshrc .zsh.d 2>/dev/null || true
stow -D -d "$DOTFILES" -t "$HOME" . 2>/dev/null || true

echo "==> Respaldando configuraciones que serán reemplazadas..."
mapfile -d '' config_entries < <(
    find "$DOTFILES/.config" -mindepth 1 -maxdepth 1 -print0 | sort -z
)
for source in "${config_entries[@]}"; do
    relative_path="${source#"$DOTFILES/"}"
    backup_target "$HOME/$relative_path" "$relative_path"
done

backup_target "$HOME/.zshrc" .zshrc
backup_target "$HOME/.zsh.d" .zsh.d

echo "==> Stoweando Dotfiles como paquete de HOME..."
stow -d "$DOTFILES" -t "$HOME" .

if [[ -d "$BACKUP_DIR" ]]; then
    echo "Las configuraciones anteriores quedaron en: $BACKUP_DIR"
fi
echo "Dotfiles enlazados con Stow."
