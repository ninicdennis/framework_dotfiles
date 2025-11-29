#!/usr/bin/env bash

# Keybinds cheatsheet script
# Parses Hyprland config and displays keybinds in fzf with categories

CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

# Categorize a keybind based on its action
categorize() {
    local action="$1"
    
    case "$action" in
        *workspace*|*movetoworkspace*) echo "WORKSPACES" ;;
        *wallpaper*) echo "WALLPAPER" ;;
        *waybar*) echo "WAYBAR" ;;
        *keybinds*) echo "HELP" ;;
        *killactive*|*exit*|*hyprlock*|*powermenu*) echo "SYSTEM" ;;
        *"\$browser"*|*"\$fileman"*|*"\$menu"*|*"\$terminal"*|*alacritty*|*dolphin*|*firefox*|*wofi*) echo "APPLICATIONS" ;;
        *nmtui*|*bluetui*|*pulsemixer*|*btop*|*clipse*|*pavucontrol*) echo "UTILITIES" ;;
        *togglefloating*|*fullscreen*|*togglesplit*|*pin*|*centerwindow*) echo "WINDOW CONTROL" ;;
        *movefocus*|*movewindow*|*swapwindow*) echo "WINDOW NAVIGATION" ;;
        *resizeactive*|*resizewindow*|*submap*resize*|*escape*|*return*) echo "WINDOW RESIZE" ;;
        *hyprshot*|*print*) echo "SCREENSHOTS" ;;
        *xf86audio*|*playerctl*) echo "MEDIA" ;;
        *xf86monbrightness*) echo "BRIGHTNESS" ;;
        *powerprofile*) echo "POWER PROFILE" ;;
        *tailscale*) echo "NETWORK" ;;
        *mouse:*) echo "MOUSE" ;;
        *) echo "OTHER" ;;
    esac
}

# Parse keybinds from hyprland.conf
parse_keybinds() {
    grep "^bind" "$CONFIG_FILE" | \
    awk '{
        # Extract bind type
        if ($1 == "bind") type = ""
        else if ($1 == "bindm") type = "[MOUSE] "
        else if ($1 == "binde") type = "[REPEAT] "
        else if ($1 == "bindl") type = "[LOCKED] "
        else type = ""
        
        # Remove "bind* = " from beginning
        sub(/^bind[elms]* = /, "")
        
        # Split by comma
        split($0, parts, ", ")
        
        keys = type parts[1]
        action = ""
        for (i = 2; i <= length(parts); i++) {
            if (i > 2) action = action ", "
            action = action parts[i]
        }
        
        # Replace $mainMod with SUPER
        gsub(/\$mainMod/, "SUPER", keys)
        gsub(/\$SCRIPTS_DIR/, "~/.config/hypr/scripts", action)
        
        # Only print if we have both keys and action
        if (keys != "" && action != "") {
            printf "%s|%s|%s\n", keys, action, tolower(action)
        }
    }'
}

# Parse keybinds from hyprland.conf and add category
parse_and_categorize() {
    while IFS='|' read -r keys action action_lower; do
        category=$(categorize "$action_lower")
        printf "%s|%s|%s|%s\n" "$category" "$keys" "$action" "$action_lower"
    done
}

# Format with categories
format_with_categories() {
    local current_category=""
    
    # ANSI color codes (Catppuccin Mocha)
    local PINK="\033[38;2;245;194;231m"
    local BLUE="\033[38;2;137;180;250m"
    local PEACH="\033[38;2;250;179;135m"
    local GREEN="\033[38;2;166;227;161m"
    local YELLOW="\033[38;2;249;226;175m"
    local RED="\033[38;2;243;139;168m"
    local MAUVE="\033[38;2;203;166;247m"
    local TEAL="\033[38;2;148;226;213m"
    local RESET="\033[0m"
    local BOLD="\033[1m"
    
    while IFS='|' read -r category keys action action_lower; do
        # Print category header if it changed
        if [[ "$category" != "$current_category" ]]; then
            if [[ -n "$current_category" ]]; then
                echo ""
            fi
            
            # Color based on category
            case "$category" in
                "APPLICATIONS") color="$BLUE" ;;
                "WORKSPACES") color="$MAUVE" ;;
                "WINDOW CONTROL") color="$PEACH" ;;
                "WINDOW NAVIGATION") color="$YELLOW" ;;
                "WINDOW RESIZE") color="$YELLOW" ;;
                "SYSTEM") color="$RED" ;;
                "MEDIA") color="$GREEN" ;;
                "UTILITIES") color="$TEAL" ;;
                "WALLPAPER") color="$PINK" ;;
                "WAYBAR") color="$PINK" ;;
                "SCREENSHOTS") color="$PEACH" ;;
                "BRIGHTNESS") color="$YELLOW" ;;
                "POWER PROFILE") color="$GREEN" ;;
                "NETWORK") color="$BLUE" ;;
                "MOUSE") color="$MAUVE" ;;
                "HELP") color="$MAUVE" ;;
                "OTHER") color="$RESET" ;;
                *) color="$RESET" ;;
            esac
            
            echo -e "${BOLD}${color}━━━━━━━━━━━━ $category ━━━━━━━━━━━━${RESET}"
            current_category="$category"
        fi
        
        printf "  %-38s → %s\n" "$keys" "$action"
    done
}

# Display in fzf with nice formatting
parse_keybinds | parse_and_categorize | sort -t'|' -k1,1 -k2,2 | format_with_categories | fzf \
    --ansi \
    --header="Hyprland Keybindings - Type to search, ESC to close" \
    --header-first \
    --reverse \
    --height=100% \
    --border=rounded \
    --prompt="Search: " \
    --info=inline \
    --color="header:#f38ba8,prompt:#cba6f7,pointer:#f5c2e7,hl:#f9e2af,hl+:#f9e2af" \
    --no-mouse \
    --bind='esc:abort'
