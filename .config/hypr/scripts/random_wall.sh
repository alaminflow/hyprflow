#!/usr/bin/env bash
# ==============================================================================
# random_wall.sh - Random wallpaper changer for Hyprland using Hyprpaper
# ==============================================================================
set -euo pipefail

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"

# 1. Fallback if primary directory does not exist
if [ ! -d "${WALLPAPER_DIR}" ]; then
    if [ -d "${HOME}/.config/hypr/wallpapers" ]; then
        WALLPAPER_DIR="${HOME}/.config/hypr/wallpapers"
    else
        echo "Error: Wallpaper directory not found at ${WALLPAPER_DIR}"
        command -v notify-send &>/dev/null && notify-send -u low "Wallpaper Error" "No wallpaper directory found at ~/Pictures/Wallpapers"
        exit 1
    fi
fi

# 2. Pick a random image file (case-insensitive for .png, .jpg, .jpeg, .webp)
WALLPAPER=$(find "${WALLPAPER_DIR}" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" \
\) 2>/dev/null | shuf -n 1)

if [ -z "${WALLPAPER:-}" ]; then
    echo "No wallpapers found in ${WALLPAPER_DIR}"
    command -v notify-send &>/dev/null && notify-send -u low "Wallpaper Error" "No valid image files found in ${WALLPAPER_DIR}"
    exit 1
fi

# 3. Ensure hyprpaper is running
if ! pgrep -x hyprpaper >/dev/null 2>&1; then
    hyprpaper &
    sleep 0.5
fi

# 4. Apply wallpaper to all active monitors using modern hyprpaper IPC
MONITORS=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name' 2>/dev/null || hyprctl monitors 2>/dev/null | awk '/Monitor/{print $2}')

if [ -n "${MONITORS}" ]; then
    for mon in ${MONITORS}; do
        hyprctl hyprpaper wallpaper "${mon},${WALLPAPER},cover" 2>/dev/null || true
    done
fi

# Broadcast to all monitors / fallback
hyprctl hyprpaper wallpaper ",${WALLPAPER},cover" 2>/dev/null || true

# 5. Optional notification feedback
WALLPAPER_NAME="$(basename "${WALLPAPER}")"
command -v notify-send &>/dev/null && notify-send -u low -t 2000 -i "${WALLPAPER}" "Wallpaper Changed" "${WALLPAPER_NAME}" 2>/dev/null || true
