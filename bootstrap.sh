#!/usr/bin/env bash
# ==============================================================================
#  hyprflow - Arch Linux + Hyprland (TokyoNight) Web Bootstrapper
# ==============================================================================
#  One-line installation command:
#  bash -c "$(curl -fsSL https://raw.githubusercontent.com/alaminflow/hyprflow/main/bootstrap.sh)"
# ==============================================================================

set -euo pipefail

REPO_URL="https://github.com/alaminflow/hyprflow.git"
TARGET_DIR="${HOME}/.dotfiles"

# Colors
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_CYAN="\033[1;36m"
C_BLUE="\033[1;34m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"

log_info() { echo -e "${C_BLUE}[INFO]${C_RESET} $*"; }
log_ok()   { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
log_warn() { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
log_err()  { echo -e "${C_RED}[ERROR]${C_RESET} $*"; }

banner() {
    clear 2>/dev/null || true
    echo -e "${C_CYAN}${C_BOLD}"
    cat << "EOF"
  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
      Arch Linux • Hyprland • Waybar • Walker • TokyoNight
                  https://github.com/alaminflow/hyprflow
EOF
    echo -e "${C_RESET}"
    echo -e "================================================================"
    echo -e " One-Line Web Installer Bootstrapper"
    echo -e "================================================================"
    echo ""
}

banner

# 1. Root check (must NOT run as root, needs normal user with sudo)
if [ "$(id -u)" -eq 0 ]; then
    log_err "Please do NOT run this installer as root or via sudo directly!"
    echo "Run as your normal user. sudo will be requested when needed."
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
    log_err "Non-Arch Linux system detected. hyprflow requires Arch Linux or an Arch-based distribution."
    exit 1
fi

# 3. Ensure git is installed
if ! command -v git &>/dev/null; then
    log_info "git is required but not installed. Installing git..."
    sudo pacman -S --needed --noconfirm git
    log_ok "git installed successfully."
fi

# 4. Handle clone destination
if [ -d "${TARGET_DIR}/.git" ]; then
    log_warn "Existing hyprflow dotfiles repository detected at: ${TARGET_DIR}"
    
    # Check if stdin is a terminal or pipe
    do_update="y"
    if [ -t 0 ] || [ -e /dev/tty ]; then
        read -rp "Would you like to pull the latest changes and continue? [Y/n] " input_update < /dev/tty || input_update="y"
        do_update="${input_update:-y}"
    fi

    if [[ "${do_update}" =~ ^[Yy] ]]; then
        log_info "Pulling latest updates in: ${TARGET_DIR}..."
        git -C "${TARGET_DIR}" pull --rebase 2>/dev/null || true
        log_ok "Repository updated."
    else
        backup_dest="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
        log_warn "Moving existing dotfiles folder to: ${backup_dest}"
        mv "${TARGET_DIR}" "${backup_dest}"
        log_info "Cloning fresh repository to: ${TARGET_DIR}..."
        git clone "${REPO_URL}" "${TARGET_DIR}"
        log_ok "Repository cloned."
    fi
elif [ -d "${TARGET_DIR}" ]; then
    backup_dest="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    log_warn "Moving existing non-git directory to: ${backup_dest}"
    mv "${TARGET_DIR}" "${backup_dest}"
    log_info "Cloning fresh repository to: ${TARGET_DIR}..."
    git clone "${REPO_URL}" "${TARGET_DIR}"
    log_ok "Repository cloned."
else
    log_info "Cloning hyprflow to: ${TARGET_DIR}..."
    git clone "${REPO_URL}" "${TARGET_DIR}"
    log_ok "Repository cloned successfully!"
fi

# 5. Ensure scripts are executable
chmod +x "${TARGET_DIR}/install.sh" "${TARGET_DIR}/scripts/"*.sh "${TARGET_DIR}/.config/hypr/scripts/"*.sh 2>/dev/null || true

# 6. Transfer control to the main installer with terminal TTY
cd "${TARGET_DIR}"
log_ok "Launching interactive installation wizard..."
echo ""

if [ -e /dev/tty ]; then
    exec "${TARGET_DIR}/install.sh" "$@" < /dev/tty
else
    exec "${TARGET_DIR}/install.sh" "$@"
fi
