# Framework 13 Dotfiles

A personal collection of configuration files for my Framework 13 laptop running Arch Linux. These dotfiles cover Neovim, Hyprland, Waybar, Alacritty, tmux and zsh. The repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks for all of the configs.

Cross-platform developer configs (Neovim, tmux, zsh, Alacritty, Starship, VS Code) work on macOS as well.

## Dependencies

The following packages are required:

- `git`, `stow`
- `neovim`, `zsh`, `tmux`, `alacritty`
- `hyprland`, `waybar`, `hyprpaper`, `hypridle`, `hyprlock`, `hyprshot`
- `wofi`, `mako`
- `brightnessctl`, `foot`, `pulsemixer`, `htop`
- `ttf-jetbrains-mono-nerd`
- `starship`, `fastfetch`
- `oh-my-zsh` with plugins:
  - `zsh-autosuggestions` (installed automatically)
  - `zsh-syntax-highlighting` (installed automatically)
  - `zsh-you-should-use` (installed automatically)
  - `zsh-history-substring-search` (installed automatically)
- `visual-studio-code-bin` (optional, for VS Code configuration)

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

## Installation on macOS (Experimental)

For macOS, use the developer-focused installation that only installs cross-platform tools:

```bash
git clone https://github.com/ninicdennis/framework_dotfiles.git
cd framework_dotfiles
./install-deps-mac.sh
```

Then apply only the dev dotfiles with:

```bash
./stow.sh dev
```

This installs only the cross-platform developer configs:
- Neovim
- Alacritty
- Starship
- tmux
- zsh (with all plugins)
- VS Code
- OpenCode

Linux-specific configs (Hyprland, Waybar, wofi, etc.) are skipped.

## Stow Options

**Full installation (Linux):**
```bash
./stow.sh
```

**Dev-only installation (macOS or minimal setup):**
```bash
./stow.sh dev
```

If you want to undo the links created by GNU Stow, you can run the same command with the `-D` flag, e.g. `stow -D nvim`.

## VS Code Configuration

The VS Code configuration includes:
- `settings.json` - Editor settings
- `snippets/` - Custom code snippets
- `extensions.txt` - List of installed extensions

To restore your VS Code extensions after stowing, run:

```bash
cd ~/.config/Code/User
./install-extensions.sh
```

To update the extensions list after installing new extensions:

```bash
code --list-extensions > ~/.config/Code/User/extensions.txt
```

## What does `stow.sh` do?

`stow.sh` calls GNU Stow for each subdirectory in this repository. It also ensures that each target directory (e.g. `~/.config/nvim`) exists before stowing. 

- Running `./stow.sh` (no arguments) sets up the entire environment with all configurations
- Running `./stow.sh dev` sets up only cross-platform developer tools (useful for macOS or minimal installs)

If you want to undo the links created by GNU Stow, you can run `stow -D <package>` from the dotfiles directory, e.g. `stow -D nvim`.
