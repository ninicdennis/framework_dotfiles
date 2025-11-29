#!/usr/bin/env bash

# Zen Mode Toggle Script
# Hides distractions for focused work

STATE_FILE="/tmp/zen-mode-state"

# Store original values for restoration
ORIGINAL_BORDER_SIZE=2
ORIGINAL_GAPS_IN=4
ORIGINAL_GAPS_OUT=8
ORIGINAL_ROUNDING=8
ORIGINAL_DIM_STRENGTH=0.3

if [ -f "$STATE_FILE" ]; then
    # Exit zen mode - restore everything
    
    # Show waybar
    killall -SIGUSR1 waybar
    
    # Restore borders
    hyprctl keyword general:border_size "$ORIGINAL_BORDER_SIZE"
    
    # Restore gaps
    hyprctl keyword general:gaps_in "$ORIGINAL_GAPS_IN"
    hyprctl keyword general:gaps_out "$ORIGINAL_GAPS_OUT"
    
    # Restore rounding
    hyprctl keyword decoration:rounding "$ORIGINAL_ROUNDING"
    
    # Restore dim strength
    hyprctl keyword decoration:dim_strength "$ORIGINAL_DIM_STRENGTH"
    
    # Exit DND mode
    makoctl mode -r dnd
    
    # Remove state file
    rm "$STATE_FILE"
    
    notify-send "Zen Mode" "Disabled - Welcome back!" -t 2000 -u normal
    
else
    # Enter zen mode - minimize distractions
    
    # Hide waybar
    killall -SIGUSR1 waybar
    
    # Remove borders
    hyprctl keyword general:border_size 0
    
    # Minimize gaps
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    
    # Remove rounding for cleaner look
    hyprctl keyword decoration:rounding 0
    
    # Increase dim on inactive windows for more focus
    hyprctl keyword decoration:dim_strength 0.5
    
    # Enable Do Not Disturb
    makoctl mode -a dnd
    
    # Create state file
    touch "$STATE_FILE"
    
    notify-send "Zen Mode" "Enabled - Focus time!" -t 2000 -u low
    
fi
