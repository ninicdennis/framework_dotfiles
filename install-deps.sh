#!/bin/bash

set -e

echo "Installing dependencies for Framework 13 dotfiles..."

# Core packages
packages=(
  git
  stow
  neovim
  zsh
  tmux
  alacritty
  hyprland
  waybar
  ttf-jetbrains-mono-nerd
  wofi
  mako
  hyprpaper
  hypridle
  hyprlock
  hyprshot
  brightnessctl
  pulsemixer
  htop
  starship
  fastfetch
)

# Install with pacman
echo "Installing packages with pacman..."
sudo pacman -S --needed "${packages[@]}"

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh is already installed"
fi

echo ""
echo "All dependencies installed successfully!"
echo "Run ./stow.sh to apply the dotfiles."
