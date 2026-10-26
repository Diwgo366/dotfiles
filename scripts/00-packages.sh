#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
    echo "Este instalador de paquetes está preparado para Arch Linux y pacman." >&2
    exit 1
fi

repo_packages=(
    base-devel
    brightnessctl
    cliphist
    dbus
    eza
    fontconfig
    git
    glib2
    gnome-themes-extra
    grim
    hyprland
    hyprlock
    hyprpaper
    hyprpicker
    jq
    kitty
    libnotify
    neovim
    papirus-icon-theme
    pipewire
    pipewire-pulse
    playerctl
    polkit-kde-agent
    poppler
    python
    python-wcwidth
    qt6-imageformats
    qt6-multimedia-ffmpeg
    qt6-svg
    qt6-virtualkeyboard
    sddm
    sassc
    slurp
    starship
    stow
    thunar
    unzip
    util-linux
    wget
    wireplumber
    wl-clipboard
    wofi
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-utils
    zsh
)

aur_packages=(
    aylurs-gtk-shell
    mpvpaper
    vim-plug
)

echo "==> Instalando dependencias de los dotfiles desde los repositorios de Arch..."
sudo pacman -Syu --needed "${repo_packages[@]}"

if command -v yay >/dev/null 2>&1; then
    aur_helper=(yay -S --needed)
elif command -v paru >/dev/null 2>&1; then
    aur_helper=(paru -S --needed)
else
    echo "Instalé los paquetes oficiales, pero faltan los del AUR: ${aur_packages[*]}" >&2
    echo "Instala yay o paru y vuelve a ejecutar ./install.sh." >&2
    exit 1
fi

echo "==> Instalando dependencias del AUR..."
"${aur_helper[@]}" "${aur_packages[@]}"

echo "Dependencias de los dotfiles instaladas."
