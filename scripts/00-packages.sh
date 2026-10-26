#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    if [[ -n ${SUDO_USER:-} && ${SUDO_USER:-} != root ]]; then
        script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
        exec sudo -u "$SUDO_USER" -H bash "$script_path" "$@"
    fi
    echo "No ejecutes este script como root: yay y los paquetes del AUR no pueden instalarse como root." >&2
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    echo "Este instalador de paquetes está preparado para Arch Linux y pacman." >&2
    exit 1
fi

repo_packages=(
    acl
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
	inotify-tools
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
if ! "${aur_helper[@]}" "${aur_packages[@]}"; then
    echo "No se pudieron instalar los paquetes del AUR: ${aur_packages[*]}" >&2
    echo "Revisa el error anterior o vuelve a ejecutar ./install.sh con --keep-going." >&2
    exit 1
fi

echo "Dependencias de los dotfiles instaladas."
