#!/usr/bin/env bash
# ==============================================================================
#  Arch Linux + Hyprland (TokyoNight) Dotfiles Automated Installer
# ==============================================================================
#  GitHub: https://github.com/alaminflow/hyprflow
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Self-bootstrap if executed directly via curl/web pipe without cloned repo
if [ ! -d "${SCRIPT_DIR}/.config" ]; then
    REPO_URL="https://github.com/alaminflow/hyprflow.git"
    TARGET_DIR="${HOME}/.dotfiles"
    echo -e "\033[1;34m[INFO]\033[0m Direct web execution detected. Bootstrapping hyprflow..."
    if ! command -v git &>/dev/null; then
        sudo pacman -S --needed --noconfirm git
    fi
    if [ ! -d "${TARGET_DIR}/.git" ]; then
        git clone "${REPO_URL}" "${TARGET_DIR}"
    else
        git -C "${TARGET_DIR}" pull --rebase 2>/dev/null || true
    fi
    cd "${TARGET_DIR}"
    chmod +x install.sh scripts/*.sh .config/hypr/scripts/*.sh 2>/dev/null || true
    if [ -e /dev/tty ]; then
        exec "${TARGET_DIR}/install.sh" "$@" < /dev/tty
    else
        exec "${TARGET_DIR}/install.sh" "$@"
    fi
fi

LOG_FILE="${HOME}/.dotfiles_install.log"
if ! touch "${LOG_FILE}" 2>/dev/null; then
    LOG_FILE="/tmp/dotfiles_install.log"
    touch "${LOG_FILE}" 2>/dev/null || LOG_FILE="/dev/null"
fi

# Color codes
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_BLUE="\033[1;34m"
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"

log_info()  { echo -e "${C_BLUE}[INFO]${C_RESET} $*" | tee -a "${LOG_FILE}" 2>/dev/null || echo -e "${C_BLUE}[INFO]${C_RESET} $*"; }
log_ok()    { echo -e "${C_GREEN}[OK]${C_RESET} $*" | tee -a "${LOG_FILE}" 2>/dev/null || echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
log_warn()  { echo -e "${C_YELLOW}[WARN]${C_RESET} $*" | tee -a "${LOG_FILE}" 2>/dev/null || echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
log_err()   { echo -e "${C_RED}[ERROR]${C_RESET} $*" | tee -a "${LOG_FILE}" 2>/dev/null || echo -e "${C_RED}[ERROR]${C_RESET} $*"; }

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
EOF
    echo -e "${C_RESET}"
    echo -e "================================================================"
    echo -e " Automated Dotfiles & Environment Installer"
    echo -e "================================================================"
    echo ""
}

# 1. Pre-flight Checks
preflight_checks() {
    log_info "Running pre-flight checks..."

    # Check root
    if [ "$(id -u)" -eq 0 ]; then
        log_err "Do not run this script as root or via sudo directly!"
        echo "Please execute as a normal user: ./install.sh"
        exit 1
    fi

    # Check Arch Linux or Arch-based distribution
    is_arch=false
    if [ -f /etc/arch-release ]; then
        is_arch=true
    elif [ -f /etc/os-release ] && grep -qiE 'ID(_LIKE)?=(arch|endeavouros|cachyos|manjaro|artix|arco)' /etc/os-release; then
        is_arch=true
    fi

    if [ "${is_arch}" = false ]; then
        log_err "Non-Arch Linux system detected. These dotfiles are built for Arch Linux."
        exit 1
    fi

    # Check internet reachability (warning only, fast timeout via HTTP)
    if ! curl -s --connect-timeout 2 -m 3 --head https://archlinux.org &>/dev/null; then
        log_warn "Could not reach archlinux.org. Offline mode or proxy may be active."
    fi

    log_ok "Pre-flight checks passed."
}

prompt_read() {
    local prompt_msg="$1"
    local var_name="$2"
    if [ -e /dev/tty ]; then
        read -rp "${prompt_msg}" "${var_name}" < /dev/tty
    else
        read -rp "${prompt_msg}" "${var_name}"
    fi
}

prompt_deploy_method() {
    local default_method="copy"
    if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
        "${SCRIPT_DIR}/scripts/deploy_configs.sh" "${default_method}"
        return
    fi

    echo ""
    echo -e "${C_BOLD}Select Deployment Method:${C_RESET}"
    echo -e "  ${C_CYAN}[1]${C_RESET} Copy configs (Safe, recommended for independent edits)"
    echo -e "  ${C_CYAN}[2]${C_RESET} Symlink configs (Changes sync automatically with git repo)"
    prompt_read "Choice [1/2] (Default 1): " deploy_choice
    local method="copy"
    if [ "${deploy_choice:-1}" == "2" ]; then
        method="symlink"
    fi
    "${SCRIPT_DIR}/scripts/deploy_configs.sh" "${method}"
}

run_full_installation() {
    preflight_checks
    echo ""
    log_info "Starting Full Installation..."
    
    # Step A: Backup
    log_info "Step 1/4: Backing up existing configs..."
    "${SCRIPT_DIR}/scripts/backup.sh"

    # Step B: Install Packages
    log_info "Step 2/4: Installing packages from official repos & AUR..."
    "${SCRIPT_DIR}/scripts/install_pkgs.sh" "$@"

    # Step C: Deploy Dotfiles
    log_info "Step 3/4: Deploying configuration files & wallpapers..."
    prompt_deploy_method

    # Step D: Shell Setup
    log_info "Step 4/4: Finalizing system environment..."
    if command -v zsh &>/dev/null; then
        current_shell="$(basename "${SHELL:-bash}")"
        if [ "${current_shell}" != "zsh" ]; then
            echo ""
            prompt_read "Change default shell to zsh? [Y/n] " set_zsh
            if [[ ! "${set_zsh:-y}" =~ ^[Nn] ]]; then
                chsh -s "$(which zsh)" 2>/dev/null || true
                log_ok "Default shell set to zsh!"
            fi
        fi
    fi

    echo ""
    echo -e "${C_GREEN}${C_BOLD}================================================================${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD} Installation Complete! You're ready to rock Hyprland!         ${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}================================================================${C_RESET}"
    echo -e "Recommended next step: Log out and start Hyprland session via your display manager or uwsm."
    echo ""
}

# 2. Main Menu
main_menu() {
    banner
    echo -e "${C_BOLD}Select Installation Mode:${C_RESET}"
    echo -e "  ${C_CYAN}[1]${C_RESET} Full Installation (Packages + Themes + Dotfiles + Wallpapers + Setup)"
    echo -e "  ${C_CYAN}[2]${C_RESET} Deploy Dotfiles Only (Backup existing & copy/symlink configs)"
    echo -e "  ${C_CYAN}[3]${C_RESET} Install Packages Only (Official pacman + AUR)"
    echo -e "  ${C_CYAN}[4]${C_RESET} Restore Previous Backup"
    echo -e "  ${C_CYAN}[5]${C_RESET} Exit"
    echo ""
    
    if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
        log_info "Non-interactive environment detected. Defaulting to Deploy Dotfiles Only."
        preflight_checks
        "${SCRIPT_DIR}/scripts/backup.sh"
        "${SCRIPT_DIR}/scripts/deploy_configs.sh" "copy"
        return
    fi

    prompt_read "Enter your choice [1-5]: " choice

    case "${choice:-1}" in
        1)
            run_full_installation
            ;;
        2)
            preflight_checks
            "${SCRIPT_DIR}/scripts/backup.sh"
            prompt_deploy_method
            ;;
        3)
            preflight_checks
            "${SCRIPT_DIR}/scripts/install_pkgs.sh"
            ;;
        4)
            "${SCRIPT_DIR}/scripts/restore.sh"
            ;;
        5)
            echo "Exiting installer."
            exit 0
            ;;
        *)
            log_err "Invalid selection."
            exit 1
            ;;
    esac
}

# CLI Flags handling
if [ "${1:-}" == "--noconfirm" ] || [ "${1:-}" == "-y" ]; then
    preflight_checks
    "${SCRIPT_DIR}/scripts/backup.sh"
    "${SCRIPT_DIR}/scripts/install_pkgs.sh" --noconfirm
    "${SCRIPT_DIR}/scripts/deploy_configs.sh" "copy"
    log_ok "Unattended full installation completed."
    exit 0
elif [ "${1:-}" == "--deploy-only" ]; then
    preflight_checks
    "${SCRIPT_DIR}/scripts/backup.sh"
    method="${2:-copy}"
    "${SCRIPT_DIR}/scripts/deploy_configs.sh" "${method}"
    log_ok "Deploy-only completed."
    exit 0
elif [ "${1:-}" == "--dry-run" ]; then
    log_info "Dry run requested. Checking files and paths:"
    find "${SCRIPT_DIR}/.config" -type f
    log_ok "Dry run completed successfully."
    exit 0
fi

# Run preflight checks before interactive menu
preflight_checks
main_menu
