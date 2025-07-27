#!/bin/bash

set -e

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

stow tmux

stow zsh
