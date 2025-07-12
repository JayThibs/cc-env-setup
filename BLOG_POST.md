# The Ultimate Claude Code Multi-Instance Terminal Setup

Running multiple Claude Code instances simultaneously is a game-changer for productivity. Instead of switching between different AI conversations, you can have dedicated assistants for different tasks—one for frontend work, another for backend, a third for testing, and a fourth for documentation—all visible at once in terminal panes.

This setup gives you everything you need in **one automated install**: ultra-fast Ghostty terminal, unlimited command history, modern CLI tools, and tmux for managing multiple AI assistants effortlessly.

## What You Get in One Install

**🚀 One Command Setup:**
```bash
./install.sh
```

This automated installer gives you:

- **Ultra-fast Ghostty terminal** with perfect font sizing and window controls
- **Unlimited command history** (999 million lines) with smart search
- **Modern CLI tools** - ripgrep, fd, bat, eza, zoxide for blazing workflows  
- **tmux multiplexer** for persistent sessions and split panes
- **Auto-suggestions** that predict commands as you type
- **fzf integration** with file previews and fuzzy completion
- **Git aliases** and productivity shortcuts built-in

## Multiple Claude Code Instances Made Easy

The real power comes from running multiple AI assistants simultaneously:

```
┌─────────────────┬─────────────────┐
│ Claude Code #1  │ Claude Code #2  │
│ Frontend Work   │ Backend API     │
├─────────────────┼─────────────────┤
│ Claude Code #3  │ Claude Code #4  │
│ Writing Tests   │ Documentation   │
└─────────────────┴─────────────────┘
```

**Launch 4 instances instantly:**
```bash
cc4  # Creates a 2x2 grid of Claude Code instances
```

**Navigate effortlessly:**
- `Ctrl+A |` - Split terminal vertically  
- `Ctrl+A -` - Split terminal horizontally
- `Ctrl+H/J/K/L` - Jump between panes instantly
- `cc` - Launch new Claude Code in any pane

## Key Features That Save Hours Daily

**Smart Command Predictions:**
- Type `ec` → see `echo "test"` suggested in gray → press `→` to accept
- Unlimited history means better predictions over time

**Fuzzy Search Everything:**
- `Ctrl+T` - Find any file with live preview
- `Ctrl+R` - Search unlimited command history  
- `Alt+C` - Navigate directories with tree view
- `**<Tab>` - Fuzzy completion for any command

**Modern CLI Shortcuts:**
- `gs` → `git status`
- `ll` → detailed file listing with icons
- `z project` → jump to any previously visited directory
- `bat file.js` → syntax-highlighted file viewing

## Installation & Setup

**1. Clone and run the installer:**
```bash
git clone https://github.com/JayThibs/cc-env-setup.git
cd cc-env-setup
./install.sh
```

**2. After installation:**
- Log out/in for faster keyboard repeat and Caps Lock→Option mapping (or set manually in System Preferences)
- Open Ghostty terminal
- Run the Powerlevel10k configuration wizard
- Start using: `cc4` for 4 Claude Code instances

**3. Essential shortcuts to remember:**
```bash
# Multiple AI instances
cc4                    # Launch 4 Claude Code instances
cc                     # Launch single Claude Code
yolo                   # Launch Claude Code with dangerous permissions skip
Ctrl+A |               # Split vertically  
Ctrl+A -               # Split horizontally
Ctrl+H/J/K/L           # Navigate between panes

# Smart navigation
Ctrl+T                 # Find files with preview
Ctrl+R                 # Search command history
Alt+C                  # Navigate directories
→                      # Accept command suggestion

# Quick commands
gs                     # git status
ll                     # detailed file listing
z project              # jump to directory
```

That's it! You now have a professional terminal setup optimized for multiple Claude Code instances and modern development workflows.

## Resources

- **[Complete Setup Guide](https://github.com/JayThibs/cc-env-setup/blob/main/SETUP_GUIDE.md)** - Detailed technical reference
- **[Video: Claude Code + Tmux](https://www.youtube.com/watch?v=bWKHPelgNgs)** - See multiple AI instances in action
- **[Advanced Dotfiles](https://github.com/jplhughes/dotfiles)** - For further customization
