#!/usr/bin/env bash

# Path to your wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Exit if directory doesn't exist
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Pick a random image file
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

# Check if an image was actually found
if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1

fi

# Modern hyprpaper syntax: This automatically handles preloading,
# setting the wallpaper on all monitors, and clearing the old cache.
hyprctl hyprpaper reload ,"$WALLPAPER"