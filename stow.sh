#!/bin/bash

set -e

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow (stow) is not installed." >&2
  exit 1
fi

# Create the target directory if it doesn't exist
mkdir -p ~/.config/nvim

# Stow the contents into ~/.config/nvim
stow --target="$HOME/.config/nvim" nvim

mkdir -p ~/.config/alacritty

stow --target="$HOME/.config/alacritty" alacritty

mkdir -p ~/.config/hypr

stow --target="$HOME/.config/hypr" hypr

mkdir -p ~/.config/waybar

stow --target="$HOME/.config/waybar" waybar

mkdir -p ~/.config/wofi

stow --target="$HOME/.config/wofi" wofi

stow --target="$HOME/.config" starship

stow tmux

stow zsh
