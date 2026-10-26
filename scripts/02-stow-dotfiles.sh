#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow no está instalado. Ejecuta primero 00-packages.sh." >&2
    exit 1
fi

echo "==> Retirando enlaces de Stow de la estructura anterior..."
stow -D -d "$DOTFILES/.config" -t "$HOME/.config" . 2>/dev/null || true
stow -D -d "$DOTFILES" -t "$HOME" .zshrc .zsh.d 2>/dev/null || true
stow -D -d "$DOTFILES" -t "$HOME" . 2>/dev/null || true

echo "==> Eliminando configuraciones existentes que serán reemplazadas..."
mapfile -d '' config_entries < <(
    find "$DOTFILES/.config" -mindepth 1 -maxdepth 1 -print0 | sort -z
)
for source in "${config_entries[@]}"; do
    relative_path="${source#"$DOTFILES/"}"
    rm -rf -- "$HOME/$relative_path"
done

rm -rf -- "$HOME/.zshrc" "$HOME/.zsh.d"

echo "==> Stoweando Dotfiles como paquete de HOME..."
stow -d "$DOTFILES" -t "$HOME" .
echo "Dotfiles enlazados con Stow."
