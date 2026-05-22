#!/usr/bin/env bash
# Instalador de fuente Caskaydia Mono Nerd Font
# Descarga, instala y actualiza la caché de fuentes

FONT_NAME="CascadiaMono"
FONT_DIR="$HOME/.local/share/fonts"

mkdir -p "$FONT_DIR"

cd /tmp || exit

echo "Descargando fuente..."

wget -O "${FONT_NAME}.zip" \
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip

echo "Extrayendo..."

unzip -o "${FONT_NAME}.zip" -d "$FONT_DIR/$FONT_NAME"

echo "Actualizando caché de fuentes..."

fc-cache -fv

echo "Fuente instalada correctamente."
