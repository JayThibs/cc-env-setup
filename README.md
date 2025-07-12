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
- `~/.zshrc` - ZSH configuration with unlimited history, modern fzf integration, and smart aliases
- `~/.config/ghostty/config` - Ghostty terminal configuration with professional appearance
- `~/.tmux.conf.local` - tmux configuration for split panes
- `~/.p10k.zsh` - Powerlevel10k theme configuration
- `~/.config/nvim/init.vim` - Neovim configuration with auto-installing plugins
- `~/cc-multi.sh` - Script to launch 4 Claude Code instances

## Prerequisites

- macOS 14+ (Intel or Apple Silicon)
- Claude Code already installed
- Internet connection
- Homebrew (will be installed automatically if missing)

## What This Setup Provides

1. **Multiple Claude Code instances** - Run 2, 4, or 8 AI assistants in split panes
2. **Intelligent auto-suggestions** - Terminal predicts commands from unlimited history (press → to accept)
3. **Ultra-fast Ghostty terminal** - Professional appearance with natural text editing
4. **Modern CLI tools** - fzf with previews, ripgrep, fd, bat, eza, zoxide for blazing workflows
5. **Persistent sessions** - Your work survives terminal restarts
6. **Quick shortcuts** - `cc` to launch Claude Code, `cc4` for 4 instances, smart git aliases
7. **Enhanced navigation** - Unlimited history search, automatic directory listing with icons
8. **Productivity powerhouses** - Copy file paths with `rl`, fuzzy search with previews

## Key Shortcuts

### Ghostty Natural Text Editing
- `Cmd+Left/Right` - Jump to beginning/end of line
- `Option+Left/Right` - Navigate by word (Caps Lock mapped to Option for easy access)
- `Cmd+Backspace` - Delete to beginning of line
- `Option+Backspace` - Delete word backward

### FZF Power Features
- `Ctrl+T` - Find files and directories (with bat preview)
- `Ctrl+R` - Search unlimited history (with copy to clipboard)
- `Alt+C` - Navigate directories (with tree preview)
- `Ctrl+Y` - Copy command from history to clipboard (within Ctrl+R)
- `**<Tab>` - Fuzzy completion for any command

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
- `yolo` - Launch Claude Code with dangerous permissions skip
- `nvim` or `vim` - Open neovim editor
- `rl <file>` - Copy absolute file path to clipboard

**Note:** When you change directories using `cd`, the terminal automatically lists the directory contents - no need to type `ls`!

For detailed instructions, see BLOG_POST.md or SETUP_GUIDE.md.

## Resources & Links

### Tools Used
- **[Ghostty](https://ghostty.org/)** - Ultra-fast native terminal by Mitchell Hashimoto
- **[tmux](https://formulae.brew.sh/formula/tmux)** - Terminal multiplexer for managing sessions
- **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder with previews
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Ultra-fast text search
- **[fd](https://github.com/sharkdp/fd)** - Modern find replacement
- **[bat](https://github.com/sharkdp/bat)** - Syntax-highlighted cat replacement
- **[eza](https://github.com/eza-community/eza)** - Modern ls replacement with icons
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smart cd that learns your habits
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** - Beautiful and fast Zsh theme
- **[Oh My Zsh](https://ohmyz.sh/)** - Framework for managing Zsh configuration
- **[Oh My Tmux](https://github.com/gpakosz/.tmux)** - Self-contained tmux configuration

### Further Reading
- **[Tips and Code for Empirical Research Workflows](https://www.lesswrong.com/posts/6P8GYb4AjtPXx6LLB/tips-and-code-for-empirical-research-workflows)** - Comprehensive terminal productivity guide
- **[John's Dotfiles](https://github.com/jplhughes/dotfiles)** - Advanced dotfiles configuration example

## Video Tutorials & Inspiration

These videos showcase similar setups and demonstrate the power of tmux + AI coding:

1. **[How I Use Wezterm & Zsh For An Amazing Terminal Setup On My Mac](https://www.youtube.com/watch?v=TTgQV21X0SQ)** - Great overview of Wezterm and Zsh configuration

2. **[Claude Code + T-Mux + Worktrees: Self-Spawning AI Coder Team](https://www.youtube.com/watch?v=bWKHPelgNgs)** - Advanced techniques for running multiple AI coders with git worktrees

3. **[Exploring Coding Efficiency: Utilizing Tmux and Claude Code for AI-Powered Ray Tracing](https://www.youtube.com/watch?v=qCW1n79Thgo)** - Real-world example of using tmux panes with Claude Code

4. **[How I Use Tmux With Neovim For An Awesome Dev Workflow](https://www.youtube.com/watch?v=U-omALWIBos)** - Complete tmux + neovim workflow guide