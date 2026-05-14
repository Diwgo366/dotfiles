#!/usr/bin/env bash

# ==============================================================
# INSTALACIÓN DE CASKAYDIA MONO NERD FONT
# ==============================================================

FONT_NAME="CaskaydiaMono"
FONT_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONT_DIR"

cd /tmp || exit

echo "Descargando fuente..."

wget -O "${FONT_NAME}.zip" \
https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip

echo "Extrayendo..."

unzip -o "${FONT_NAME}.zip" -d "$FONT_DIR/$FONT_NAME"

echo "Actualizando caché de fuentes..."

fc-cache -fv

echo "Fuente instalada correctamente."
