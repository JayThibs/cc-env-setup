# Complete Claude Code Multi-Instance Setup Reference

## For Future Claude Code Instances: Everything You Need to Know

This document contains EVERYTHING needed to set up the ultimate Claude Code multi-instance terminal environment. Follow these instructions exactly to replicate the full setup.

## 🎯 What This Setup Provides

1. **Multiple Claude Code Instances**: Run several AI assistants simultaneously in split panes
2. **Intelligent Auto-Suggestions**: Commands appear in gray as you type - press → to accept
3. **Beautiful Terminal**: Ultra-fast Ghostty terminal with clean dark theme
4. **Session Management**: tmux for persistent sessions that survive restarts
5. **Smart Navigation**: Jump between directories, search files, and navigate history effortlessly
6. **Unlimited History**: Never lose a command with 999 million line history
7. **Modern CLI Tools**: fzf, ripgrep, fd, bat, eza, zoxide for blazing fast workflows

## 📋 Complete Feature List

### Terminal Features
- **Ghostty**: Ultra-fast native terminal written in Zig by Mitchell Hashimoto
- **Auto-suggestions**: Real-time command predictions based on unlimited history
- **Syntax highlighting**: Valid commands in green, invalid in red
- **Smart completions**: Case-insensitive, fuzzy matching with modern CLI tools
- **Unlimited History**: 999 million command history with instant search
- **Natural Text Editing**: Option+Arrow for word jumping, Cmd+Arrow for line navigation

### Productivity Tools
- **tmux**: Terminal multiplexer with custom keybindings
- **fzf**: Fuzzy finder with previews for files, directories, and history
- **ripgrep**: Ultra-fast text search (alias: `rg`)
- **zoxide**: Smart cd that learns your habits (alias: `z`)
- **eza**: Beautiful ls replacement with icons and tree view
- **bat**: Syntax-highlighted cat replacement with line numbers
- **fd**: Modern find replacement that respects .gitignore
- **tree**: Directory structure visualization
- **htop**: Interactive process monitor

### Claude Code Integration
- Quick launch aliases: `cc`, `ccnew`, `ccvsplit`, `cchsplit`
- tmux integration for multiple instances
- Persistent sessions across restarts

## 🚀 One-Command Installation

```bash
# For a fresh macOS system, run:
./install.sh

# Or clone first:
git clone https://github.com/JayThibs/cc-env-setup.git
cd cc-env-setup
./install.sh
```

**What the installer does:**
- ✅ **Smart detection** - skips already installed packages
- ✅ **Automated Ghostty installation** - tries Homebrew then direct download
- ✅ **Progress tracking** - shows [3/11] step progress
- ✅ **Config backups** - saves existing configs with timestamps
- ✅ **Pre-flight checks** - validates system requirements
- ✅ **One password prompt** - maintains sudo session throughout

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
# Faster key repeat for better navigation (ultra-fast settings)
defaults write -g InitialKeyRepeat -float 10.0  # Faster initial repeat
defaults write -g KeyRepeat -float 1.0          # Faster continuous repeat

# Map Caps Lock to Option key for better terminal navigation
# This must be done manually in System Settings:
# System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys
# Set Caps Lock key to: ⌥ Option

# Note: Log out and back in for these to take effect
# Or set manually: System Preferences > Keyboard > fastest settings & modifier keys
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
brew "tree"
brew "htop"

# Font (Ghostty installed separately)
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

#### ~/.zshrc (COMPLETE VERSION WITH UNLIMITED HISTORY AND MODERN FZF)
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

# History - Unlimited (practical limit)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt HIST_VERIFY               # Don't execute immediately upon history expansion

# Better completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' special-dirs true

# FZF Configuration - Modern setup with all features
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --ansi --tabstop=1 --exit-0'

# CTRL-T: Paste the selected files and directories onto the command-line
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-R: Paste the selected command from history onto the command-line  
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# ALT-C: cd into the selected directory
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --strip-cwd-prefix'
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {} | head -200'"

# Modern CLI Aliases
alias ls="eza --icons"
alias ll="eza -la --icons"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias cd="z"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias vim="nvim"
alias top="htop"

# Git Aliases (productivity boosters)
alias g="git"
alias gs="git status"
alias gc="git commit"
alias gca="git commit -a"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias ga="git add"
alias gaa="git add ."
alias gb="git branch"
alias gco="git checkout"

# Tmux Aliases
alias ta="tmux attach -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"

# Claude Code helpers
alias cc="claude code"
alias ccnew="tmux split-window -h 'claude code'"
alias ccvsplit="tmux split-window -h 'claude code'"
alias cchsplit="tmux split-window -v 'claude code'"
alias cc4="~/cc-multi.sh"
alias yolo="claude --dangerously-skip-permissions"

# Initialize tools
eval "$(zoxide init zsh)"

# FZF - Modern shell integration with key bindings and completion
source <(fzf --zsh)

# Custom FZF completion for common commands
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add any existing PATH modifications here
# export PATH="$PATH:/your/custom/path"
ZSHRC_EOF
```

#### ~/.config/ghostty/config
```bash
mkdir -p ~/.config/ghostty
cat > ~/.config/ghostty/config << 'GHOSTTY_EOF'
# Claude Code Professional Ghostty Configuration

# Font - Smaller and more readable
font-family = "MesloLGS Nerd Font"
font-size = 12
adjust-cell-height = -2

# Window appearance - With proper title bar
window-decoration = true
window-padding-x = 8
window-padding-y = 8
background-opacity = 0.92
macos-window-shadow = true

# Simple, clean appearance - no custom colors to avoid errors

# Terminal settings
scrollback-limit = 10000
confirm-close-surface = false

# Natural text editing key bindings
keybind = alt+left=text:\x1b[1;5D
keybind = alt+right=text:\x1b[1;5C
keybind = cmd+left=text:\x01
keybind = cmd+right=text:\x05
keybind = alt+backspace=text:\x17
keybind = cmd+backspace=text:\x15
GHOSTTY_EOF
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

### 11. Install Neovim Plugins
```bash
# Install vim-plug first
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install plugins
nvim +'PlugInstall --sync' +qa
```

### 12. Install Ghostty
```bash
# Option 1: Official method (recommended)
# Visit https://ghostty.org/ and download the .dmg
# Drag Ghostty.app to Applications folder

# Option 2: Community Homebrew cask
brew install --cask ghostty

# Option 3: Let the install script try both automatically
```

### 13. Configure Claude Code for Multi-line Support
```bash
claude code /terminal-setup
```

### 14. Change Default Shell to ZSH
```bash
# Add zsh to allowed shells
sudo sh -c "echo $(which zsh) >> /etc/shells"

# Change default shell
chsh -s $(which zsh)
```

## 🔑 Critical Key Bindings Reference

### Auto-Suggestions & FZF (MOST IMPORTANT!)
- `→` - Accept the gray suggestion
- `Ctrl+→` - Accept one word only
- `Tab` - Show completion menu
- `Shift+Tab` - Alternative accept
- `↑/↓` - Search matching history
- `Esc` - Clear suggestion

### FZF Power Features
- `Ctrl+T` - Find files and directories (with preview)
- `Ctrl+R` - Search unlimited history (with copy to clipboard)
- `Alt+C` - Navigate directories (with tree preview)
- `Ctrl+Y` - Copy command from history to clipboard (within Ctrl+R)
- `**<Tab>` - Fuzzy completion: `vim **<Tab>`, `cd **<Tab>`, `kill **<Tab>`

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
- `yolo` - Launch Claude Code with dangerous permissions skip
- `z dirname` - Jump to directory
- `Ctrl+T` - Fuzzy find files
- `Ctrl+R` - Fuzzy search history

## 🚨 Common Issues and Solutions

### Font Not Loading in Ghostty
```bash
# The font name MUST be exact in ~/.config/ghostty/config:
font-family = "MesloLGS Nerd Font"
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

# Test unlimited history and substring search
echo "substring test" # Then type 'test' and press up arrow - should find this

# Test natural text editing in Ghostty
# Type a long command, then use Option+Arrow to jump words

# Test auto-ls with eza
cd /tmp # Should automatically list directory contents with icons

# Test modern CLI tools
ls # Should show eza with icons
ll # Should show detailed list with icons
bat README.md # Should show syntax-highlighted file
rg "search term" # Should use ripgrep for fast search
fd filename # Should use fd instead of find
z ~/Documents # Should use zoxide for smart directory jumping

# Test FZF power features
Ctrl+T # Should open file finder with bat preview
Ctrl+R # Should open history search with copy-to-clipboard (Ctrl+Y)
Alt+C # Should open directory navigator with tree preview
vim **<Tab> # Should trigger fuzzy completion

# Test tmux
tmux new -s test
# Press Ctrl+A | to split
# Press Ctrl+H and Ctrl+L to navigate

# Test git aliases
gs # Should run git status
gc # Should run git commit
gp # Should run git push

# Test Claude Code
cc # Should launch Claude Code
cc4 # Should launch 4 instances in 2x2 grid
yolo # Should launch Claude Code with dangerous permissions skip
```

## 🎯 Final Checklist

- [ ] Ghostty opens without font errors
- [ ] Commands appear in gray as you type (unlimited history)
- [ ] Right arrow accepts suggestions
- [ ] Option+Arrow jumps by word in terminal
- [ ] Cmd+Arrow goes to line start/end
- [ ] cd automatically shows directory contents with eza icons
- [ ] Modern CLI tools work: `ls`, `ll`, `cat`, `grep`, `find` use new tools
- [ ] FZF features work: Ctrl+T, Ctrl+R, Alt+C with previews
- [ ] History search finds substrings anywhere in unlimited history
- [ ] Ctrl+A works as tmux prefix
- [ ] Can split panes with Ctrl+A | and -
- [ ] Can navigate with Ctrl+H/J/K/L
- [ ] Git aliases work: `gs`, `gc`, `gp`
- [ ] `cc` launches Claude Code
- [ ] `cc4` launches 4 instances in 2x2 grid
- [ ] `yolo` launches Claude Code with dangerous permissions skip
- [ ] Powerlevel10k shows git status
- [ ] Keyboard repeat faster after logout/login
- [ ] Caps Lock mapped to Option for easier word navigation

## 💡 Pro Tips

1. **Build History**: The more commands you use, the better predictions (unlimited storage!)
2. **Use Modern Aliases**: `gs` for git status, `ll` for detailed listing, `z` for smart cd
3. **FZF Power**: Use Ctrl+T for files, Ctrl+R for history, Alt+C for directories
4. **Smart Jumps**: After visiting directories, use `z partial-name` with zoxide
5. **Session Names**: Use descriptive tmux session names
6. **Persistent Sessions**: tmux sessions survive terminal restarts
7. **Git Workflow**: Use `gaa` (git add .), `gcm "message"` (git commit -m), `gp` (git push)
8. **File Operations**: Use `fd` instead of find, `rg` instead of grep, `bat` instead of cat

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

This completes the ENTIRE modern setup with Ghostty, unlimited history, and fzf power features. Save this document for future reference!

## 🆕 What's New in This Version

- ⚡ **Ghostty Terminal** - Ultra-fast native terminal by Mitchell Hashimoto
- 📜 **Unlimited History** - 999 million commands with advanced options
- 🔍 **Modern FZF Integration** - File previews, history search, directory navigation
- 🛠️ **Enhanced CLI Tools** - fd, ripgrep, bat, eza, tree, htop
- 🎯 **Smart Aliases** - Productivity-focused git, tmux, and CLI shortcuts
- 🔄 **Automated Installation** - Smart detection, progress tracking, config backups
- ⌨️ **Natural Text Editing** - Word/line navigation in terminal
- 🎨 **Clean Dark Theme** - Professional, readable appearance