# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages configuration files using GNU Stow. It contains configuration setups for:

- **Neovim**: Based on kickstart.nvim with custom modifications
- **Zsh**: Shell configuration with plugins and aliases  
- **Tmux**: Terminal multiplexer configuration with custom key bindings
- **Bin utilities**: Custom scripts for tmux session management

## Architecture

The repository follows a stow-based structure where each top-level directory represents a "package" that can be symlinked to the home directory:

- `nvim/` → Contains `.config/nvim/` structure
- `zsh/` → Contains `.zshrc` file
- `tmux/` → Contains tmux configuration files
- `bin/` → Contains `.local/bin/` with utility scripts
- `WindowsTerminal/` → Windows Terminal settings

## Installation and Management

### Main Commands

- `./install` - Install all dotfiles using stow (uses zsh, requires `STOW_FOLDERS` and `DOTFILES` env vars)
- `./fedora` - Fedora-specific installation script that sets default folders and runs install
- `stow -D <folder>` - Remove symlinks for a specific package
- `stow <folder>` - Create symlinks for a specific package

### Environment Variables

- `STOW_FOLDERS` - Comma-separated list of folders to install (default: "tmux,zsh,bin,lvim")  
- `DOTFILES` - Path to dotfiles directory (default: `$HOME/.dotfiles`)

### Pre-commit Hooks

The repository uses pre-commit with StyLua formatter for Lua files:
- `pre-commit run --all-files` - Run all pre-commit hooks
- `pre-commit install` - Install pre-commit hooks

## Neovim Configuration

Based on kickstart.nvim with these key points:

- Single-file configuration approach in `init.lua`
- Uses Lazy.nvim plugin manager
- Requires external dependencies: git, make, unzip, C compiler, ripgrep, fd-find
- Custom plugins are in `lua/custom/plugins/init.lua`
- Lock file is tracked in version control (`lazy-lock.json`)

### Development Commands
- `stylua .` - Format Lua code (configured via `.stylua.toml`)

## Custom Scripts

Located in `bin/.local/bin/`:

- `tmux-sessionizer` - Tmux session management utility
- `tmux-cht.sh` - Cheat sheet integration for tmux

## Key Bindings

### Tmux
- `<prefix>-i` - Open tmux cheat sheet
- `<prefix>-f` - Open tmux sessionizer
- Mouse mode is enabled

### Zsh
- `vim` aliased to `nvim`
- Uses oh-my-zsh with plugins: git, macos, iterm2, ssh-agent, aliases, python, docker, git-auto-fetch, golang, helm, kubectl, kubectx, tmux
- RTX/mise tool integration

## Code Quality

- YAML files follow yamllint configuration in `.yamllint`
- Lua files use StyLua formatting
- Pre-commit hooks enforce code quality standards