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

- macOS 14+ (Intel or Apple Silicon)
- Claude Code already installed
- Internet connection
- Homebrew (will be installed automatically if missing)

## What This Setup Provides

1. **Multiple Claude Code instances** - Run 2, 4, or 8 AI assistants in split panes
2. **Intelligent auto-suggestions** - Terminal predicts commands as you type (press → to accept)
3. **Beautiful Wezterm terminal** - GPU-accelerated with Tokyo Night theme & natural text editing
4. **Persistent sessions** - Your work survives terminal restarts
5. **Quick shortcuts** - `cc` to launch Claude Code, `cc4` for 4 instances
6. **Enhanced navigation** - Substring history search, automatic directory listing
7. **Productivity tools** - Copy file paths with `rl`, fuzzy search everything

## Key Shortcuts

### WezTerm Natural Text Editing
- `Cmd+Left/Right` - Jump to beginning/end of line
- `Option+Left/Right` - Navigate by word
- `Cmd+Backspace` - Delete to beginning of line
- `Option+Backspace` - Delete word backward

### tmux (prefix: `Ctrl+A`)
- `Ctrl+A |` or `Ctrl+A h` - Split vertically
- `Ctrl+A -` or `Ctrl+A v` - Split horizontally
- `Ctrl+A r` - Reload tmux config
- `Ctrl+A m` - Maximize/minimize pane
- `Ctrl+A H/J/K/L` - Resize panes (hold to repeat)
- `Ctrl+A u/i/o/p` - Alternative resize (up/left/right/down)
- `Ctrl+H/J/K/L` - Navigate between panes (no prefix!)

### Copy Mode
- `Ctrl+A [` - Enter copy mode
- `v` - Start selection (in copy mode)
- `y` - Copy selection (in copy mode)
- Double-click - Select and copy word

### Quick Launchers
- `cc` - Launch Claude Code
- `cc4` - Launch 4 Claude Code instances in a grid
- `nvim` or `vim` - Open neovim editor
- `rl <file>` - Copy absolute file path to clipboard

**Note:** When you change directories using `cd`, the terminal automatically lists the directory contents - no need to type `ls`!

For detailed instructions, see BLOG_POST.md or SETUP_GUIDE.md.

## Resources & Links

### Tools Used
- **[tmux](https://formulae.brew.sh/formula/tmux)** - Terminal multiplexer for managing sessions
- **[WezTerm](https://wezterm.org/install/macos.html)** - GPU-accelerated terminal emulator  
- **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** - Beautiful and fast Zsh theme
- **[Oh My Zsh](https://ohmyz.sh/)** - Framework for managing Zsh configuration
- **[Oh My Tmux](https://github.com/gpakosz/.tmux)** - Self-contained tmux configuration

### Further Reading
- **[John's Dotfiles](https://github.com/jplhughes/dotfiles)** - Advanced dotfiles configuration example

## Video Tutorials & Inspiration

These videos showcase similar setups and demonstrate the power of tmux + AI coding:

1. **[How I Use Wezterm & Zsh For An Amazing Terminal Setup On My Mac](https://www.youtube.com/watch?v=TTgQV21X0SQ)** - Great overview of Wezterm and Zsh configuration

2. **[Claude Code + T-Mux + Worktrees: Self-Spawning AI Coder Team](https://www.youtube.com/watch?v=bWKHPelgNgs)** - Advanced techniques for running multiple AI coders with git worktrees

3. **[Exploring Coding Efficiency: Utilizing Tmux and Claude Code for AI-Powered Ray Tracing](https://www.youtube.com/watch?v=qCW1n79Thgo)** - Real-world example of using tmux panes with Claude Code

4. **[How I Use Tmux With Neovim For An Awesome Dev Workflow](https://www.youtube.com/watch?v=U-omALWIBos)** - Complete tmux + neovim workflow guide