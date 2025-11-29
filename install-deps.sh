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
  swww
  hypridle
  hyprlock
  hyprshot
  brightnessctl
  pulsemixer
  htop
  btop
  starship
  fastfetch
  bat
  fd
  fzf
  eza
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

# Install zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions is already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting is already installed"
fi

# Install zsh-you-should-use plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use" ]; then
  echo "Installing zsh-you-should-use..."
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use
else
  echo "zsh-you-should-use is already installed"
fi

# Install zsh-history-substring-search plugin
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
  echo "Installing zsh-history-substring-search..."
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
else
  echo "zsh-history-substring-search is already installed"
fi

echo ""
echo "All dependencies installed successfully!"
echo "Run ./stow.sh to apply the dotfiles."
