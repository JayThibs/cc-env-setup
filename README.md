# Claude Code Multi-Instance Terminal Setup

This repository contains everything needed to set up a beautiful terminal environment for running multiple Claude Code instances simultaneously.

## Files in This Repository

- **BLOG_POST.md** - A beginner-friendly blog post explaining the setup and benefits
- **SETUP_GUIDE.md** - Complete technical reference for future Claude Code instances to replicate the setup  
- **install.sh** - One-line installer script that automates the entire setup

## Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JayThibs/cc-env-setup/main/install.sh)
```

## What Gets Installed

The installer creates these configuration files in your home directory:
- `~/.zshrc` - ZSH configuration with auto-suggestions and aliases
- `~/.wezterm.lua` - Wezterm terminal configuration
- `~/.tmux.conf.local` - tmux configuration for split panes
- `~/.p10k.zsh` - Powerlevel10k theme configuration
- `~/cc-multi.sh` - Script to launch 4 Claude Code instances

## Prerequisites

- macOS 14+
- Claude Code already installed
- Internet connection

## What This Setup Provides

1. **Multiple Claude Code instances** - Run 2, 4, or 8 AI assistants in split panes
2. **Intelligent auto-suggestions** - Terminal predicts commands as you type (press → to accept)
3. **Beautiful Wezterm terminal** - GPU-accelerated with Tokyo Night theme
4. **Persistent sessions** - Your work survives terminal restarts
5. **Quick shortcuts** - `cc` to launch Claude Code, `cc4` for 4 instances

## Key Shortcuts

- `Ctrl+A` - tmux prefix (press first for tmux commands)
- `Ctrl+A |` - Split vertically
- `Ctrl+A -` - Split horizontally
- `Ctrl+H/J/K/L` - Navigate between panes (no prefix needed!)
- `cc` - Launch Claude Code
- `cc4` - Launch 4 Claude Code instances in a grid

For detailed instructions, see BLOG_POST.md or SETUP_GUIDE.md.