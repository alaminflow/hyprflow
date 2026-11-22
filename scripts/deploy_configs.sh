#!/usr/bin/env bash
# ==============================================================================
# deploy_configs.sh - Deploy configurations to ~/.config and home directory
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOT_CONFIG_DIR="${SCRIPT_DIR}/.config"

log_info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
log_ok()    { echo -e "\033[1;32m[OK]\033[0m $*"; }
log_warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }

DEPLOY_METHOD="${1:-copy}" # "copy" or "symlink"

log_info "Deploying dotfiles using method: ${DEPLOY_METHOD}"

# 1. Ensure required target directories exist
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/.local/bin"

# 2. Deploy .config entries
for entry in "${DOT_CONFIG_DIR}"/*; do
    [ -e "${entry}" ] || continue
    name="$(basename "${entry}")"
    
    # Skip Code and Cursor in bulk loop; handled specially to isolate settings from runtime caches
    if [ "${name}" == "Code" ] || [ "${name}" == "Cursor" ]; then
        continue
    fi
    
    dest="${HOME}/.config/${name}"

    if [ "${DEPLOY_METHOD}" == "symlink" ]; then
        rm -rf "${dest}"
        ln -sfn "${entry}" "${dest}"
        log_ok "Symlinked: ~/.config/${name} -> ${entry}"
    else
        rm -rf "${dest}"
        cp -a "${entry}" "${dest}"
        log_ok "Copied: ~/.config/${name}"
    fi
done

# 3. Handle Editor User configurations (prevents IDE cache pollution into dotfiles repo)
if [ -f "${DOT_CONFIG_DIR}/Code/User/settings.json" ]; then
    mkdir -p "${HOME}/.config/Code/User"
    if [ "${DEPLOY_METHOD}" == "symlink" ]; then
        ln -sf "${DOT_CONFIG_DIR}/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
        log_ok "Symlinked: ~/.config/Code/User/settings.json"
    else
        cp "${DOT_CONFIG_DIR}/Code/User/settings.json" "${HOME}/.config/Code/User/settings.json"
        log_ok "Copied: ~/.config/Code/User/settings.json"
    fi
fi

if [ -f "${DOT_CONFIG_DIR}/Cursor/User/settings.json" ]; then
    mkdir -p "${HOME}/.config/Cursor/User"
    if [ "${DEPLOY_METHOD}" == "symlink" ]; then
        ln -sf "${DOT_CONFIG_DIR}/Cursor/User/settings.json" "${HOME}/.config/Cursor/User/settings.json"
        log_ok "Symlinked: ~/.config/Cursor/User/settings.json"
    else
        cp "${DOT_CONFIG_DIR}/Cursor/User/settings.json" "${HOME}/.config/Cursor/User/settings.json"
        log_ok "Copied: ~/.config/Cursor/User/settings.json"
    fi
fi

# 4. Deploy home dotfiles
HOME_FILES=(".zshrc" ".bashrc" ".gtkrc-2.0")
for file in "${HOME_FILES[@]}"; do
    src="${SCRIPT_DIR}/${file}"
    dest="${HOME}/${file}"
    if [ -f "${src}" ]; then
        if [ "${DEPLOY_METHOD}" == "symlink" ]; then
            rm -f "${dest}"
            ln -sf "${src}" "${dest}"
            log_ok "Symlinked: ~/${file} -> ${src}"
        else
            cp -a "${src}" "${dest}"
            log_ok "Copied: ~/${file}"
        fi
    fi
done

# 5. Deploy curated wallpapers (nullglob prevents literal * if empty)
shopt -s nullglob
WALLPAPER_FILES=("${SCRIPT_DIR}/assets/wallpapers"/*)
shopt -u nullglob

if [ ${#WALLPAPER_FILES[@]} -gt 0 ]; then
    log_info "Deploying ${#WALLPAPER_FILES[@]} wallpapers to: ${HOME}/Pictures/Wallpapers/"
    for wp in "${WALLPAPER_FILES[@]}"; do
        dest_wp="${HOME}/Pictures/Wallpapers/$(basename "${wp}")"
        if [ ! -f "${dest_wp}" ]; then
            cp "${wp}" "${dest_wp}"
        fi
    done
    log_ok "Wallpapers deployed successfully!"
fi

# 6. Ensure executable permissions for all user scripts
find "${HOME}/.config/hypr" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

# 7. Load dconf settings (GTK theme, fonts, icons, dark mode)
if command -v dconf &>/dev/null && [ -f "${SCRIPT_DIR}/dconf/dconf-settings.ini" ]; then
    log_info "Applying desktop & theme settings via dconf..."
    if dconf load / < "${SCRIPT_DIR}/dconf/dconf-settings.ini" 2>/dev/null; then
        log_ok "dconf settings applied successfully!"
    else
        log_warn "dconf settings deferred (no active D-Bus session in this environment; will apply on GUI login)."
    fi
fi

# 8. Update XDG user directories (graceful fallback)
if command -v xdg-user-dirs-update &>/dev/null; then
    xdg-user-dirs-update 2>/dev/null || true
fi

# 9. Enable systemd user services (graceful fallback)
if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload 2>/dev/null || true
    if [ -f "${HOME}/.config/systemd/user/elephant.service" ]; then
        systemctl --user enable elephant.service 2>/dev/null || true
        log_ok "Configured elephant.service"
    fi
fi

log_ok "Configurations deployed cleanly without errors!"
