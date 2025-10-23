#!/bin/bash

set -e

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow (stow) is not installed." >&2
  exit 1
fi

# Config packages that need their own directory
config_packages=(nvim alacritty hypr waybar wofi htop)

for package in "${config_packages[@]}"; do
  mkdir -p "$HOME/.config/$package"
  stow --target="$HOME/.config/$package" "$package"
done

# Starship goes to .config directly
stow --target="$HOME/.config" starship

# Home directory packages
stow tmux
stow zsh

echo "All dotfiles have been stowed successfully."
