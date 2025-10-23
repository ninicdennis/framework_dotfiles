# Framework 13 Dotfiles

A personal collection of configuration files for my Framework 13 laptop running Arch Linux. These dotfiles cover Neovim, Hyprland, Waybar, Alacritty, tmux and zsh. The repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks for all of the configs.

## Dependencies

The following packages are required:

- `git`, `stow`
- `neovim`, `zsh`, `tmux`, `alacritty`
- `hyprland`, `waybar`, `hyprpaper`, `hypridle`, `hyprlock`, `hyprshot`
- `wofi`, `mako`
- `brightnessctl`, `foot`, `pulsemixer`, `htop`
- `ttf-jetbrains-mono-nerd`
- `starship`, `fastfetch`
- `oh-my-zsh` (installed automatically by the install script)

Additional optional dependencies may be required by plugins in the Neovim configuration. Check the plugin list for details.

## Installation on Arch Linux

Clone this repository and install dependencies:

```bash
git clone https://github.com/ninicdennis/framework_dotfiles.git
cd framework_dotfiles
./install-deps.sh
```

Then apply the dotfiles with:

```bash
./stow.sh
```

This will create symlinks in your `$HOME` directory pointing to the configuration files in this repository. By default the script stows each directory into `~/.config/<name>` (for example `nvim`, `alacritty`, `hypr`, `waybar`) and also places the `tmux` and `zsh` files directly in your home directory.

If you want to undo the links created by GNU Stow, you can run the same command with the `-D` flag, e.g. `stow -D nvim`.

## What does `stow.sh` do?

`stow.sh` simply calls GNU Stow for each subdirectory in this repository. It also ensures that each target directory (e.g. `~/.config/nvim`) exists before stowing. Running the script once will set up the entire environment by symlinking all provided configurations to their expected locations.
