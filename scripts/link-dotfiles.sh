#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Dotfiles"

echo "==> Stowing .config contents..."
stow -d "$DOTFILES/.config" -t "$HOME/.config" .

echo "==> Stowing home-level dotfiles..."
stow -d "$DOTFILES" -t "$HOME" .zshrc .zsh.d .local scripts

echo "==> Linking .cache/wal..."
ln -sf "$DOTFILES/.cache/wal" "$HOME/.cache/wal"

echo "Done."
