#!/bin/bash

set -e

echo "Installing developer dependencies for macOS..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

# Core developer packages
packages=(
  git
  stow
  neovim
  zsh
  tmux
  alacritty
  starship
  fastfetch
)

# Install with Homebrew
echo "Installing packages with Homebrew..."
brew install "${packages[@]}"

# Install JetBrains Mono Nerd Font
echo "Installing JetBrains Mono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font

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
echo "Note: Only stow the following configs on macOS:"
echo "  - alacritty"
echo "  - nvim"
echo "  - starship"
echo "  - tmux"
echo "  - zsh"
echo ""
echo "Example: stow alacritty nvim starship tmux zsh"
