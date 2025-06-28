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
- `~/.config/nvim/init.vim` - Neovim configuration with plugins and Tokyo Night theme
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

## Video Tutorials & Inspiration

These videos showcase similar setups and demonstrate the power of tmux + AI coding:

1. **[How I Use Wezterm & Zsh For An Amazing Terminal Setup On My Mac](https://www.youtube.com/watch?v=TTgQV21X0SQ)** - Great overview of Wezterm and Zsh configuration

2. **[Claude Code + T-Mux + Worktrees: Self-Spawning AI Coder Team](https://www.youtube.com/watch?v=bWKHPelgNgs)** - Advanced techniques for running multiple AI coders with git worktrees

3. **[Exploring Coding Efficiency: Utilizing Tmux and Claude Code for AI-Powered Ray Tracing](https://www.youtube.com/watch?v=qCW1n79Thgo)** - Real-world example of using tmux panes with Claude Code

4. **[How I Use Tmux With Neovim For An Awesome Dev Workflow](https://www.youtube.com/watch?v=U-omALWIBos)** - Complete tmux + neovim workflow guide