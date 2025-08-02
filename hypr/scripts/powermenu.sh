#!/usr/bin/env bash

# Define your menu entries
options=(
  "  Shutdown"
  "  Reboot"
  "  Suspend"
  "  Logout"
  "  Lock"
)

# Show the menu, capture selection
choice=$(printf "%s\n" "${options[@]}" |
  wofi --dmenu --prompt="Power Menu")

# Dispatch based on choice
case "$choice" in
*Shutdown) systemctl poweroff ;;
*Reboot) systemctl reboot ;;
*Suspend)
  hyprlock &
  systemctl suspend
  ;;
*Logout)
  hyprctl dispatch exit
  ;;
*Lock)
  hyprlock
  ;;
*) exit 1 ;;
esac
