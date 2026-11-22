#!/usr/bin/env bash
# ==============================================================================
# backup.sh - Safely backup existing user configurations
# ==============================================================================
set -euo pipefail

BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

log_info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
log_ok()    { echo -e "\033[1;32m[OK]\033[0m $*"; }
log_warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }

mkdir -p "${BACKUP_DIR}/.config"

# Config folders to backup if they exist
CONFIG_TARGETS=(
    "hypr"
    "waybar"
    "walker"
    "kitty"
    "ghostty"
    "fastfetch"
    "btop"
    "starship.toml"
    "pavucontrol.ini"
    "qalculate"
    "gtk-3.0"
    "gtk-4.0"
    "nwg-look"
    "xsettingsd"
    "Thunar"
    "xfce4"
    "featherpad"
    "systemd"
    "mimeapps.list"
    "user-dirs.dirs"
    "user-dirs.locale"
    "swaync"
    "mpv"
    "Code/User/settings.json"
    "Cursor/User/settings.json"
)

backed_up_count=0

for target in "${CONFIG_TARGETS[@]}"; do
    src="${HOME}/.config/${target}"
    dest="${BACKUP_DIR}/.config/${target}"
    if [ -e "${src}" ] || [ -L "${src}" ]; then
        mkdir -p "$(dirname "${dest}")"
        cp -a "${src}" "${dest}"
        backed_up_count=$((backed_up_count + 1))
    fi
done

# Home dotfiles
HOME_TARGETS=(".zshrc" ".bashrc" ".gtkrc-2.0")
for file in "${HOME_TARGETS[@]}"; do
    if [ -e "${HOME}/${file}" ] || [ -L "${HOME}/${file}" ]; then
        cp -a "${HOME}/${file}" "${BACKUP_DIR}/${file}"
        backed_up_count=$((backed_up_count + 1))
    fi
done

if [ ${backed_up_count} -gt 0 ]; then
    log_ok "Backed up ${backed_up_count} existing configuration(s) to: ${BACKUP_DIR}"
    echo "${BACKUP_DIR}" > "${HOME}/.dotfiles_last_backup"
else
    log_info "No pre-existing configurations found (clean environment detected)."
    rm -rf "${BACKUP_DIR}"
fi
