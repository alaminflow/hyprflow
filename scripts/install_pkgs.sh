#!/usr/bin/env bash
# ==============================================================================
# install_pkgs.sh - Automated package installation for Arch Linux + AUR
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKGS_DIR="${SCRIPT_DIR}/packages"

log_info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
log_ok()    { echo -e "\033[1;32m[OK]\033[0m $*"; }
log_warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_err()   { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

# 1. Root check (must NOT run as root, needs normal user with sudo)
if [ "$(id -u)" -eq 0 ]; then
    log_err "Please do NOT run this script as root! Run as normal user with sudo privileges."
    exit 1
fi

# 2. Check Arch Linux
if [ ! -f /etc/arch-release ]; then
    log_err "This installation script is designed for Arch Linux."
    exit 1
fi

# 3. Detect or install AUR helper (yay / paru)
detect_aur_helper() {
    if command -v yay &>/dev/null; then
        echo "yay"
    elif command -v paru &>/dev/null; then
        echo "paru"
    else
        echo ""
    fi
}

AUR_HELPER="$(detect_aur_helper)"

if [ -z "${AUR_HELPER}" ]; then
    log_warn "No AUR helper (yay/paru) detected."
    read -rp "Would you like to automatically install yay-bin? [Y/n] " install_yay
    if [[ "${install_yay}" =~ ^[Nn] ]]; then
        log_err "An AUR helper is required to install desktop packages. Aborting package install."
        exit 1
    fi

    log_info "Bootstrapping yay-bin from AUR..."
    sudo pacman -S --needed --noconfirm base-devel git
    BUILD_DIR="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "${BUILD_DIR}/yay-bin"
    (cd "${BUILD_DIR}/yay-bin" && makepkg -si --noconfirm)
    rm -rf "${BUILD_DIR}"
    AUR_HELPER="yay"
    log_ok "yay-bin installed successfully!"
fi

# 4. Filter and install official pacman packages
install_pacman_pkgs() {
    log_info "Updating package databases..."
    sudo pacman -Sy

    log_info "Reading official packages from: ${PKGS_DIR}/pacman-pkgs.txt"
    mapfile -t PACMAN_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/pacman-pkgs.txt")

    if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
        log_info "Installing official repository packages..."
        sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
        log_ok "Official packages installed successfully!"
    fi
}

# 5. Filter and install AUR packages
install_aur_pkgs() {
    log_info "Reading AUR packages from: ${PKGS_DIR}/aur-pkgs.txt"
    mapfile -t AUR_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/aur-pkgs.txt")

    if [ ${#AUR_PKGS[@]} -gt 0 ]; then
        log_info "Installing AUR packages using ${AUR_HELPER}..."
        "${AUR_HELPER}" -S --needed --noconfirm "${AUR_PKGS[@]}"
        log_ok "AUR packages installed successfully!"
    fi
}

# 6. Optional apps
install_optional_apps() {
    if [ -f "${PKGS_DIR}/apps-pkgs.txt" ]; then
        mapfile -t APP_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/apps-pkgs.txt")
        if [ ${#APP_PKGS[@]} -gt 0 ]; then
            echo ""
            read -rp "Would you like to install optional apps (Brave, VS Code)? [y/N] " install_apps
            if [[ "${install_apps}" =~ ^[Yy] ]]; then
                log_info "Installing optional applications..."
                "${AUR_HELPER}" -S --needed --noconfirm "${APP_PKGS[@]}"
                log_ok "Optional applications installed!"
            fi
        fi
    fi
}

# Execution
install_pacman_pkgs
install_aur_pkgs
install_optional_apps

log_ok "All packages processed successfully!"
