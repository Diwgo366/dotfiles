#!/bin/bash
# apply-gtk-theme.sh
# Aplica tema GTK, iconos, fuentes y color-scheme vía gsettings

set -e

echo "Aplicando configuración GTK..."

# Tema
gsettings set org.gnome.desktop.interface gtk-theme 'mi-tema-gtk'
echo "✓ Tema: mi-tema-gtk"

# Iconos
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
echo "✓ Iconos: Papirus"

# Cursor
gsettings set org.gnome.desktop.interface cursor-theme 'Future-cyan-cursors'
echo "✓ Cursor: Future-cyan-cursors"

# Fuentes
gsettings set org.gnome.desktop.interface font-name 'CaskaydiaMono Nerd Font 10'
echo "✓ Fuente principal: CaskaydiaMono Nerd Font 10"

gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaMono Nerd Font Mono 10'
echo "✓ Fuente monoespaciada: CaskaydiaMono Nerd Font Mono 10"

# Color scheme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "✓ Tema de color: oscuro"

echo ""
echo "✅ Todas las configuraciones GTK aplicadas correctamente"
