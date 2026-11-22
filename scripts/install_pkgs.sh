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

AUTO_YES=false
if [ "${1:-}" == "--noconfirm" ] || [ "${1:-}" == "-y" ] || [ ! -t 0 ]; then
    AUTO_YES=true
fi

# 1. Root check (must NOT run as root, needs normal user with sudo)
if [ "$(id -u)" -eq 0 ]; then
    log_err "Please do NOT run this script as root! Run as a normal user with sudo privileges."
    exit 1
fi

# 2. Check Arch Linux / Arch-based distributions
is_arch() {
    if [ -f /etc/arch-release ]; then
        return 0
    fi
    if [ -f /etc/os-release ]; then
        if grep -qiE 'ID(_LIKE)?=(arch|endeavouros|cachyos|manjaro|artix|arco)' /etc/os-release; then
            return 0
        fi
    fi
    return 1
}

if ! is_arch; then
    log_err "Non-Arch Linux system detected. These dotfiles require Arch Linux or an Arch-based distribution."
    exit 1
fi

# 3. Detect or bootstrap AUR helper (yay / paru)
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
    install_yay="y"
    if [ "${AUTO_YES}" = false ]; then
        read -rp "Would you like to automatically bootstrap yay-bin from AUR? [Y/n] " input_yay
        install_yay="${input_yay:-y}"
    fi

    if [[ "${install_yay}" =~ ^[Nn] ]]; then
        log_warn "Proceeding without AUR helper. AUR packages will be skipped."
    else
        log_info "Bootstrapping yay-bin from AUR..."
        sudo pacman -S --needed --noconfirm base-devel git
        BUILD_DIR="$(mktemp -d)"
        if git clone https://aur.archlinux.org/yay-bin.git "${BUILD_DIR}/yay-bin" 2>/dev/null; then
            (cd "${BUILD_DIR}/yay-bin" && makepkg -si --noconfirm)
            rm -rf "${BUILD_DIR}"
            AUR_HELPER="yay"
            log_ok "yay-bin installed successfully!"
        else
            rm -rf "${BUILD_DIR}"
            log_warn "Failed to clone yay-bin. Skipping AUR packages."
        fi
    fi
fi

# 4. Install official repository packages
install_pacman_pkgs() {
    log_info "Reading official packages from: ${PKGS_DIR}/pacman-pkgs.txt"
    mapfile -t PACMAN_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/pacman-pkgs.txt")

    if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
        log_info "Installing official repository packages (${#PACMAN_PKGS[@]} packages)..."
        # Try batch install first; fallback to individual packages if any single package is missing
        if ! sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"; then
            log_warn "Batch install encountered issues. Installing packages individually to isolate missing ones..."
            for pkg in "${PACMAN_PKGS[@]}"; do
                sudo pacman -S --needed --noconfirm "${pkg}" 2>/dev/null || log_warn "Could not install: ${pkg} (skipped)"
            done
        fi
        log_ok "Official repository packages processed!"
    fi
}

# 5. Install AUR packages
install_aur_pkgs() {
    if [ -z "${AUR_HELPER}" ]; then
        log_warn "AUR helper not available; skipping AUR packages."
        return 0
    fi

    log_info "Reading AUR packages from: ${PKGS_DIR}/aur-pkgs.txt"
    mapfile -t AUR_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/aur-pkgs.txt")

    if [ ${#AUR_PKGS[@]} -gt 0 ]; then
        log_info "Installing AUR packages using ${AUR_HELPER} (${#AUR_PKGS[@]} packages)..."
        if ! "${AUR_HELPER}" -S --needed --noconfirm "${AUR_PKGS[@]}"; then
            log_warn "Batch AUR install encountered issues. Installing AUR packages individually..."
            for pkg in "${AUR_PKGS[@]}"; do
                "${AUR_HELPER}" -S --needed --noconfirm "${pkg}" 2>/dev/null || log_warn "Could not install AUR package: ${pkg} (skipped)"
            done
        fi
        log_ok "AUR packages processed!"
    fi
}

# 6. Optional apps
install_optional_apps() {
    if [ -z "${AUR_HELPER}" ] || [ ! -f "${PKGS_DIR}/apps-pkgs.txt" ]; then
        return 0
    fi

    mapfile -t APP_PKGS < <(grep -vE '^\s*#|^\s*$' "${PKGS_DIR}/apps-pkgs.txt")
    if [ ${#APP_PKGS[@]} -eq 0 ]; then
        return 0
    fi

    install_apps="n"
    if [ "${AUTO_YES}" = false ]; then
        echo ""
        read -rp "Would you like to install optional apps (Brave, VS Code)? [y/N] " input_apps
        install_apps="${input_apps:-n}"
    fi

    if [[ "${install_apps}" =~ ^[Yy] ]]; then
        log_info "Installing optional applications..."
        "${AUR_HELPER}" -S --needed --noconfirm "${APP_PKGS[@]}" 2>/dev/null || true
        log_ok "Optional applications processed!"
    fi
}

# Execution
install_pacman_pkgs
install_aur_pkgs
install_optional_apps

log_ok "All packages processed successfully!"
