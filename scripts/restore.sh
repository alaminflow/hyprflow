#!/usr/bin/env bash
# ==============================================================================
# restore.sh - Restore user configurations from a previous backup
# ==============================================================================
set -euo pipefail

log_info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
log_ok()    { echo -e "\033[1;32m[OK]\033[0m $*"; }
log_err()   { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

BACKUP_PATH="${1:-}"

if [ -z "${BACKUP_PATH}" ]; then
    if [ -f "${HOME}/.dotfiles_last_backup" ]; then
        BACKUP_PATH="$(cat "${HOME}/.dotfiles_last_backup")"
    fi
fi

if [ -z "${BACKUP_PATH}" ] || [ ! -d "${BACKUP_PATH}" ]; then
    log_err "No backup directory specified or found."
    echo "Usage: ./scripts/restore.sh /path/to/.dotfiles_backup_YYYYMMDD_HHMMSS"
    exit 1
fi

log_info "Restoring configurations from: ${BACKUP_PATH}"

if [ -d "${BACKUP_PATH}/.config" ]; then
    cp -r "${BACKUP_PATH}/.config"/* "${HOME}/.config/" 2>/dev/null || true
fi

for f in .zshrc .bashrc .gtkrc-2.0; do
    if [ -f "${BACKUP_PATH}/${f}" ]; then
        cp "${BACKUP_PATH}/${f}" "${HOME}/${f}"
    fi
done

log_ok "Configurations restored successfully from: ${BACKUP_PATH}"
