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

# 1. Create target directories
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/Pictures/Wallpapers"
mkdir -p "${HOME}/.local/bin"

# 2. Deploy .config entries
for entry in "${DOT_CONFIG_DIR}"/*; do
    [ -e "${entry}" ] || continue
    name="$(basename "${entry}")"
    
    # Skip Code and Cursor in bulk loop; they are handled specially below to prevent cache pollution
    if [ "${name}" == "Code" ] || [ "${name}" == "Cursor" ]; then
        continue
    fi
    
    dest="${HOME}/.config/${name}"

    if [ "${DEPLOY_METHOD}" == "symlink" ]; then
        rm -rf "${dest}"
        ln -sf "${entry}" "${dest}"
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

# 5. Deploy curated wallpapers
if [ -d "${SCRIPT_DIR}/assets/wallpapers" ]; then
    log_info "Deploying wallpapers to: ${HOME}/Pictures/Wallpapers/"
    cp -n "${SCRIPT_DIR}/assets/wallpapers"/* "${HOME}/Pictures/Wallpapers/" 2>/dev/null || true
    log_ok "Wallpapers deployed successfully!"
fi

# 6. Replace __HOME__ path placeholders in deployed hypr configs
if [ -f "${HOME}/.config/hypr/hyprpaper.conf" ]; then
    sed -i "s|__HOME__|${HOME}|g" "${HOME}/.config/hypr/hyprpaper.conf"
fi

# 7. Ensure executable permissions for scripts
if [ -d "${HOME}/.config/hypr/scripts" ]; then
    chmod +x "${HOME}/.config/hypr/scripts"/* 2>/dev/null || true
fi

# 8. Load dconf settings (GTK theme, fonts, icons, dark mode)
if command -v dconf &>/dev/null && [ -f "${SCRIPT_DIR}/dconf/dconf-settings.ini" ]; then
    log_info "Applying desktop & theme settings via dconf..."
    dconf load / < "${SCRIPT_DIR}/dconf/dconf-settings.ini"
    log_ok "dconf settings applied successfully!"
fi

# 9. Update XDG user directories
if command -v xdg-user-dirs-update &>/dev/null; then
    xdg-user-dirs-update
fi

# 10. Enable systemd user services
if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload 2>/dev/null || true
    if [ -f "${HOME}/.config/systemd/user/elephant.service" ]; then
        systemctl --user enable elephant.service 2>/dev/null || true
        log_ok "Enabled elephant.service"
    fi
fi

log_ok "Configurations deployed cleanly without errors!"
