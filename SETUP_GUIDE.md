# Complete Claude Code Multi-Instance Setup Reference

## For Future Claude Code Instances: Everything You Need to Know

This document contains EVERYTHING needed to set up the ultimate Claude Code multi-instance terminal environment. Follow these instructions exactly to replicate the full setup.

## 🎯 What This Setup Provides

1. **Multiple Claude Code Instances**: Run several AI assistants simultaneously in split panes
2. **Intelligent Auto-Suggestions**: Commands appear in gray as you type - press → to accept
3. **Beautiful Terminal**: GPU-accelerated Wezterm with Tokyo Night theme
4. **Session Management**: tmux for persistent sessions that survive restarts
5. **Smart Navigation**: Jump between directories, search files, and navigate history effortlessly

## 📋 Complete Feature List

### Terminal Features
- **Wezterm**: GPU-accelerated, ligature support, true colors
- **Auto-suggestions**: Real-time command predictions based on history
- **Syntax highlighting**: Valid commands in green, invalid in red
- **Smart completions**: Case-insensitive, fuzzy matching
- **Enhanced history**: 50,000 command history with instant search

### Productivity Tools
- **tmux**: Terminal multiplexer with custom keybindings
- **fzf**: Fuzzy finder for files, directories, and history
- **ripgrep**: Ultra-fast text search
- **zoxide**: Smart cd that learns your habits
- **eza**: Beautiful ls replacement with icons
- **bat**: Syntax-highlighted cat replacement

### Claude Code Integration
- Quick launch aliases: `cc`, `ccnew`, `ccvsplit`, `cchsplit`
- tmux integration for multiple instances
- Persistent sessions across restarts

## 🚀 One-Command Installation

```bash
# For a fresh macOS system, run:
bash <(curl -fsSL https://raw.githubusercontent.com/JayThibs/cc-env-setup/main/install.sh)
```

## 📝 Step-by-Step Manual Installation

### 1. Install Homebrew (if not installed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Apple Silicon Macs, add to PATH:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Configure macOS Settings
```bash
# Faster key repeat for better navigation
defaults write -g InitialKeyRepeat -float 10.0
defaults write -g KeyRepeat -float 1.0
# Log out and back in for these to take effect
```

### 3. Install All Required Packages
```bash
# Create a Brewfile and install everything at once
cat > /tmp/Brewfile << 'EOF'
tap "homebrew/cask-fonts"

# Core tools
brew "git"
brew "zsh"
brew "tmux"
brew "neovim"

# Modern CLI tools
brew "fzf"
brew "eza"
brew "zoxide"
brew "ripgrep"
brew "fd"
brew "bat"
brew "jq"

# Terminal and font
cask "wezterm"
cask "font-meslo-lg-nerd-font"
EOF

brew bundle --file=/tmp/Brewfile
```

### 4. Install Oh My Zsh
```bash
# Non-interactive installation
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 5. Install Powerlevel10k Theme
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 6. Install ZSH Plugins
```bash
# Auto-suggestions for command prediction
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Better completions
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# History substring search
git clone https://github.com/zsh-users/zsh-history-substring-search \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

### 7. Install Oh My Tmux
```bash
cd ~
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -sf .tmux/.tmux.conf
cd -
```

### 8. Create ALL Configuration Files

#### ~/.zshrc (COMPLETE VERSION WITH AUTO-SUGGESTIONS)
```bash
cat > ~/.zshrc << 'ZSHRC_EOF'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
  fzf
  tmux
)

source $ZSH/oh-my-zsh.sh

# ZSH Auto-suggestions Configuration - CRITICAL FOR PREDICTIONS
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7a7a7a,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# Key bindings for auto-suggestions
bindkey '→' autosuggest-accept              # Right arrow to accept
bindkey '^[[C' autosuggest-accept          # Right arrow (alternate)
bindkey '^I' complete-word                 # Tab for completion
bindkey '^[[Z' autosuggest-accept          # Shift+Tab to accept
bindkey '^→' forward-word                  # Ctrl+Right for one word
bindkey '^[[1;5C' forward-word             # Ctrl+Right (alternate)

# Better history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Better completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' special-dirs true

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Aliases
alias ls="eza --icons"
alias ll="eza -la --icons"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias cd="z"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias vim="nvim"

# Claude Code aliases
alias cc="claude code"
alias ccnew="tmux split-window -h 'claude code'"
alias ccvsplit="tmux split-window -h 'claude code'"
alias cchsplit="tmux split-window -v 'claude code'"
alias ccwindow="tmux new-window -n 'Claude Code' 'claude code'"
alias cc4="~/cc-multi.sh"

# Git aliases
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# tmux aliases
alias ta="tmux attach -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"

# Initialize tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add any existing PATH modifications here
# export PATH="$PATH:/your/custom/path"
ZSHRC_EOF
```

#### ~/.wezterm.lua
```bash
cat > ~/.wezterm.lua << 'WEZTERM_EOF'
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font (MUST be exact name)
config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 16.0

-- Appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.color_scheme = 'Tokyo Night'
config.hide_tab_bar_if_only_one_tab = true

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Natural text editing keybindings
config.keys = {
  -- Word navigation
  { key = 'LeftArrow', mods = 'OPT', action = wezterm.action.SendString '\x1b[1;5D' },
  { key = 'RightArrow', mods = 'OPT', action = wezterm.action.SendString '\x1b[1;5C' },
  
  -- Line navigation
  { key = 'LeftArrow', mods = 'CMD', action = wezterm.action.SendString '\x01' },
  { key = 'RightArrow', mods = 'CMD', action = wezterm.action.SendString '\x05' },
  
  -- Word deletion
  { key = 'Backspace', mods = 'OPT', action = wezterm.action.SendString '\x17' },
  { key = 'Delete', mods = 'OPT', action = wezterm.action.SendString '\x1b[3;5~' },
  
  -- Line deletion
  { key = 'Backspace', mods = 'CMD', action = wezterm.action.SendString '\x15' },
  { key = 'Delete', mods = 'CMD', action = wezterm.action.SendString '\x0b' },
}

-- Scrollback
config.scrollback_lines = 10000

-- Window padding
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Initial size
config.initial_cols = 120
config.initial_rows = 40

return config
WEZTERM_EOF
```

#### ~/.tmux.conf.local
```bash
cat > ~/.tmux.conf.local << 'TMUX_EOF'
# General settings
set -g history-limit 50000
set -g mouse on

# CRITICAL: Change prefix to Ctrl-a
set -gu prefix2
unbind C-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Custom pane split bindings (| and -)
bind | split-window -h -c '#{pane_current_path}' #!important
bind - split-window -v -c '#{pane_current_path}' #!important

# Navigate panes WITHOUT PREFIX - just Ctrl+Direction
bind -n C-h select-pane -L #!important
bind -n C-j select-pane -D #!important
bind -n C-k select-pane -U #!important
bind -n C-l select-pane -R #!important

# Resize panes (with prefix)
bind -r H resize-pane -L 5 #!important
bind -r J resize-pane -D 5 #!important
bind -r K resize-pane -U 5 #!important
bind -r L resize-pane -R 5 #!important

# Maximize pane toggle
bind m resize-pane -Z #!important

# Quick Claude Code launchers
bind C new-window -n "Claude Code" "claude code" #!important
bind V split-window -h "claude code" #!important
bind S split-window -v "claude code" #!important

# Settings
tmux_conf_new_window_retain_current_path=true
tmux_conf_new_pane_retain_current_path=true
set -g mode-keys vi

# Theme colors (Tokyo Night)
tmux_conf_theme_colour_1="#15161e"
tmux_conf_theme_colour_2="#1a1b26"
tmux_conf_theme_colour_3="#565f89"
tmux_conf_theme_colour_4="#7aa2f7"
tmux_conf_theme_colour_5="#e0af68"
tmux_conf_theme_colour_6="#15161e"
tmux_conf_theme_colour_7="#c0caf5"

# Copy to system clipboard
tmux_conf_copy_to_os_clipboard=true
TMUX_EOF
```

#### ~/.p10k.zsh (Minimal config - will be replaced by wizard)
```bash
cat > ~/.p10k.zsh << 'P10K_EOF'
# Temporary minimal config - run 'p10k configure' to customize
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time)
P10K_EOF
```

### 9. Create Multi-Instance Launcher Script
```bash
cat > ~/cc-multi.sh << 'LAUNCHER_EOF'
#!/bin/bash
# Launch 4 Claude Code instances in a 2x2 grid

SESSION="claude-multi"

# Kill existing session if it exists
tmux kill-session -t $SESSION 2>/dev/null

# Create new session with 4 panes
tmux new-session -d -s $SESSION -n 'Claude Code'

# Launch first Claude Code (top-left)
tmux send-keys -t $SESSION:0 'claude code' C-m

# Split vertically (top-right)
tmux split-window -h -t $SESSION:0
tmux send-keys -t $SESSION:0 'claude code' C-m

# Select first pane and split horizontally (bottom-left)
tmux select-pane -t $SESSION:0.0
tmux split-window -v -t $SESSION:0
tmux send-keys -t $SESSION:0 'claude code' C-m

# Select second pane and split horizontally (bottom-right)
tmux select-pane -t $SESSION:0.2
tmux split-window -v -t $SESSION:0
tmux send-keys -t $SESSION:0 'claude code' C-m

# Balance panes and attach
tmux select-layout -t $SESSION:0 tiled
tmux attach-session -t $SESSION
LAUNCHER_EOF

chmod +x ~/cc-multi.sh
```

### 10. Install FZF Key Bindings
```bash
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
```

### 11. Configure Claude Code for Multi-line Support
```bash
claude code /terminal-setup
```

### 12. Change Default Shell to ZSH
```bash
# Add zsh to allowed shells
sudo sh -c "echo $(which zsh) >> /etc/shells"

# Change default shell
chsh -s $(which zsh)
```

## 🔑 Critical Key Bindings Reference

### Auto-Suggestions (MOST IMPORTANT!)
- `→` - Accept the gray suggestion
- `Ctrl+→` - Accept one word only
- `Tab` - Show completion menu
- `Shift+Tab` - Alternative accept
- `↑/↓` - Search matching history
- `Esc` - Clear suggestion

### tmux Controls (Prefix: Ctrl+A)
- `Ctrl+A |` - Split vertically
- `Ctrl+A -` - Split horizontally
- `Ctrl+H/J/K/L` - Navigate (NO PREFIX!)
- `Ctrl+A H/J/K/L` - Resize panes
- `Ctrl+A m` - Maximize toggle
- `Ctrl+A c` - New window
- `Ctrl+A d` - Detach session
- `Ctrl+A V` - Split with Claude Code
- `Ctrl+A S` - Split horizontal with Claude Code

### Quick Commands
- `cc` - Launch Claude Code
- `ccnew` - Split and launch Claude Code
- `cc4` or `~/cc-multi.sh` - Launch 4 instances
- `z dirname` - Jump to directory
- `Ctrl+T` - Fuzzy find files
- `Ctrl+R` - Fuzzy search history

## 🚨 Common Issues and Solutions

### Font Not Loading in Wezterm
```bash
# The font name MUST be exact:
config.font = wezterm.font('MesloLGS Nerd Font')
# NOT 'MesloLGS NF' or any other variation
```

### Auto-suggestions Not Working
1. Make sure plugins are installed:
   ```bash
   ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
   ```
2. Reload shell: `exec zsh`
3. Check if right arrow is bound: `bindkey | grep autosuggest`

### tmux Key Bindings Not Working
1. Make sure you're using `Ctrl+A` (not `Ctrl+B`)
2. Reload config: `tmux source-file ~/.tmux.conf`
3. Exit tmux completely and start fresh

### Powerlevel10k Not Loading
1. Run: `p10k configure`
2. If that fails: `rm ~/.p10k.zsh && exec zsh`

## 📊 Testing Your Setup

Run these commands to verify everything is working:

```bash
# Test auto-suggestions
echo "test" # Type 'ec' and you should see 'echo "test"' in gray

# Test history substring search
echo "substring test" # Then type 'test' and press up arrow - should find this

# Test natural text editing in terminal
# Type a long command, then use Option+Arrow to jump words

# Test auto-ls
cd /tmp # Should automatically list directory contents

# Test rl command
rl # Should re-list current directory with icons

# Test tmux
tmux new -s test
# Press Ctrl+A | to split
# Press Ctrl+H and Ctrl+L to navigate

# Test fuzzy finding
Ctrl+T # Should open file finder
Ctrl+R # Should open history search with substring matching

# Test aliases
cc # Should launch Claude Code
z # Should show zoxide is working
ls # Should show icons
```

## 🎯 Final Checklist

- [ ] Wezterm opens without font errors
- [ ] Commands appear in gray as you type
- [ ] Right arrow accepts suggestions
- [ ] Option+Arrow jumps by word in terminal
- [ ] Cmd+Arrow goes to line start/end
- [ ] cd automatically shows directory contents
- [ ] rl command re-lists directory
- [ ] History search finds substrings anywhere
- [ ] Ctrl+A works as tmux prefix
- [ ] Can split panes with Ctrl+A | and -
- [ ] Can navigate with Ctrl+H/J/K/L
- [ ] `cc` launches Claude Code
- [ ] Powerlevel10k shows git status

## 💡 Pro Tips

1. **Build History**: The more commands you use, the better predictions
2. **Use Aliases**: `cc`, `ccnew`, etc. for quick Claude Code launches
3. **Smart Jumps**: After visiting directories, use `z partial-name`
4. **Session Names**: Use descriptive tmux session names
5. **Persistent Sessions**: tmux sessions survive terminal restarts

## 🚀 Quick Start for Multiple Claude Code

```bash
# Method 1: Quick 4-instance grid
~/cc-multi.sh

# Method 2: Manual control
tmux new -s project
cc                    # First instance
Ctrl+A |             # Split vertically
cc                    # Second instance
Ctrl+A -             # Split horizontally
cc                    # Third instance

# Navigate between them
Ctrl+H/J/K/L
```

This completes the ENTIRE setup. Save this document for future reference!