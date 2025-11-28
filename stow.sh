#!/bin/bash

set -e

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow (stow) is not installed." >&2
  exit 1
fi

# Check for "dev" argument
if [ "$1" = "dev" ]; then
  echo "Installing dev-only dotfiles..."
  
  # Dev-focused config packages
  dev_config_packages=(nvim alacritty opencode)
  
  for package in "${dev_config_packages[@]}"; do
    mkdir -p "$HOME/.config/$package"
    stow --target="$HOME/.config/$package" "$package"
  done
  
  # Starship goes to .config directly
  stow --target="$HOME/.config" starship
  
  # Home directory packages
  stow tmux
  stow zsh
  
  # VS Code configuration
  mkdir -p "$HOME/.config/Code"
  stow --target="$HOME/.config/Code" vscode
  
  echo "Dev dotfiles have been stowed successfully."
  exit 0
fi

# Full installation (default)
# Config packages that need their own directory
config_packages=(nvim alacritty hypr waybar wofi htop opencode)

for package in "${config_packages[@]}"; do
  mkdir -p "$HOME/.config/$package"
  stow --target="$HOME/.config/$package" "$package"
done

# Starship goes to .config directly
stow --target="$HOME/.config" starship

# Home directory packages
stow tmux
stow zsh

stow  --target="$HOME/.local" local

# VS Code configuration - this one has a specific name
mkdir -p "$HOME/.config/Code"
stow --target="$HOME/.config/Code" vscode


echo "All dotfiles have been stowed successfully."
