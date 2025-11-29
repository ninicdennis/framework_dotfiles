#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Wallpapers"

# Ensure swww daemon is running
ensure_daemon() {
    if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon &
        sleep 1
    fi
}

# Get current wallpaper
get_current() {
    ensure_daemon
    swww query | grep -oP 'image: \K.*' | head -1
}

# Set a specific wallpaper
set_wallpaper() {
    local wallpaper="$1"
    ensure_daemon
    swww img "$wallpaper" \
        --transition-type wipe \
        --transition-duration 2 \
        --transition-fps 60
}

# Get a random wallpaper
random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1
}

# Next wallpaper (cycle through alphabetically)
next_wallpaper() {
    local current=$(get_current)
    local wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort))
    
    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[$i]}" == "$current" ]]; then
            local next_idx=$(( (i + 1) % ${#wallpapers[@]} ))
            echo "${wallpapers[$next_idx]}"
            return
        fi
    done
    
    # If current not found, return first
    echo "${wallpapers[0]}"
}

# Previous wallpaper
prev_wallpaper() {
    local current=$(get_current)
    local wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort))
    
    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[$i]}" == "$current" ]]; then
            local prev_idx=$(( (i - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]} ))
            echo "${wallpapers[$prev_idx]}"
            return
        fi
    done
    
    # If current not found, return last
    echo "${wallpapers[-1]}"
}

# Main command handling
case "$1" in
    random)
        set_wallpaper "$(random_wallpaper)"
        ;;
    next)
        set_wallpaper "$(next_wallpaper)"
        ;;
    prev)
        set_wallpaper "$(prev_wallpaper)"
        ;;
    set)
        if [[ -f "$2" ]]; then
            set_wallpaper "$2"
        else
            echo "File not found: $2"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {random|next|prev|set <path>}"
        exit 1
        ;;
esac
