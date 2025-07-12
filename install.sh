#!/bin/bash

# Claude Code Ultimate Environment Installer
# This script sets up everything needed for multiple Claude Code instances

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Progress tracking
TOTAL_STEPS=11
CURRENT_STEP=0

# Function to print status with progress
status() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}] ==>${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    echo -e "${RED}Installation failed at step ${CURRENT_STEP}/${TOTAL_STEPS}${NC}"
    echo -e "${YELLOW}You can re-run this script to resume from where it left off.${NC}"
    exit 1
}

# Create backup function
backup_existing_config() {
    local file=$1
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        echo -e "${YELLOW}Backed up existing $file to $backup${NC}"
    fi
}

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Claude Code Multi-Instance Terminal Setup Installer       ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Pre-flight checks
status "Running pre-flight checks..."

# Check sudo access upfront
if ! sudo -n true 2>/dev/null; then
    echo -e "${BLUE}==>${NC} This script requires administrative privileges."
    echo -e "${BLUE}==>${NC} You will be prompted for your password once at the beginning."
    sudo -v || error "Failed to obtain administrative privileges"
fi

# Keep sudo alive in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check internet connection
if ! ping -c 1 google.com &> /dev/null; then
    error "No internet connection detected. Please connect to the internet and try again."
fi

# Check available disk space (require at least 1GB)
AVAILABLE_KB=$(df / | tail -1 | awk '{print $4}')
if [ "$AVAILABLE_KB" -lt 1048576 ]; then
    error "Insufficient disk space. At least 1GB free space required."
fi

success "Pre-flight checks passed"

# Check if macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This installer is for macOS only"
fi

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo -e "${YELLOW}Warning: Claude Code doesn't appear to be installed.${NC}"
    echo "Please install Claude Code first: https://claude.ai/download"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 1: Check/Install Homebrew 
# First try to add Homebrew to PATH in case it's installed but not in current PATH
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Now check if brew command is available
if ! command -v brew &> /dev/null; then
    status "Installing Homebrew..."
    echo "This may take a few minutes and will ask for your password..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        success "Homebrew installed (Apple Silicon)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
        success "Homebrew installed (Intel)"
    else
        error "Homebrew installation failed. Please install manually from https://brew.sh"
    fi
else
    success "Homebrew already installed"
fi

# Step 2: Configure macOS
status "Configuring macOS keyboard settings..."
defaults write -g InitialKeyRepeat -float 10.0
defaults write -g KeyRepeat -float 1.0

echo ""
echo -e "${YELLOW}💡 Note: Keyboard repeat speed will be faster after you log out/in${NC}"
echo -e "${YELLOW}   Or set manually: System Preferences > Keyboard > fastest settings${NC}"
echo ""

success "Keyboard configured for faster repeat"

# Step 3: Install packages (only if not already installed)
status "Checking and installing terminal tools..."

# Add homebrew fonts tap
brew tap homebrew/cask-fonts 2>/dev/null || true

# Function to install package if not already installed
install_if_missing() {
    local package=$1
    local type=${2:-"brew"}
    
    if [[ "$type" == "cask" ]]; then
        if ! brew list --cask "$package" &>/dev/null; then
            status "Installing $package..."
            brew install --cask "$package"
        else
            success "$package already installed"
        fi
    else
        if ! brew list "$package" &>/dev/null; then
            status "Installing $package..."
            brew install "$package"
        else
            success "$package already installed"
        fi
    fi
}

# Install core tools
install_if_missing git
install_if_missing zsh
install_if_missing tmux
install_if_missing neovim

# Install modern CLI tools  
install_if_missing fzf
install_if_missing eza
install_if_missing zoxide
install_if_missing ripgrep
install_if_missing fd
install_if_missing bat
install_if_missing jq
install_if_missing tree
install_if_missing htop

# Install applications
install_if_missing font-meslo-lg-nerd-font cask

# Install Ghostty (try automated first, fall back to manual)
if ! command -v ghostty &> /dev/null && [ ! -d "/Applications/Ghostty.app" ]; then
    status "Installing Ghostty..."
    
    # Try Homebrew first (community-maintained but automated)
    if brew install --cask ghostty 2>/dev/null; then
        success "Ghostty installed via Homebrew"
    else
        echo -e "${YELLOW}Homebrew install failed. Attempting direct download...${NC}"
        
        # Try to download and install automatically
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        
        # Get latest release URL from GitHub API (fallback method)
        if curl -s "https://api.github.com/repos/ghostty-org/ghostty/releases/latest" | grep -o "https://.*\.dmg" | head -1 > /tmp/ghostty_url.txt 2>/dev/null; then
            GHOSTTY_URL=$(cat /tmp/ghostty_url.txt)
            status "Downloading Ghostty from: $GHOSTTY_URL"
            
            if curl -L -o "ghostty.dmg" "$GHOSTTY_URL" 2>/dev/null; then
                status "Mounting and installing Ghostty..."
                hdiutil attach "ghostty.dmg" -nobrowse -quiet
                cp -R "/Volumes/Ghostty/Ghostty.app" "/Applications/"
                hdiutil detach "/Volumes/Ghostty" -quiet
                success "Ghostty installed successfully"
            else
                echo -e "${YELLOW}Automatic download failed. Manual installation required:${NC}"
                echo "1. Visit: https://ghostty.org/"
                echo "2. Download the .dmg file"
                echo "3. Open the .dmg and drag Ghostty to Applications folder"
            fi
        else
            echo -e "${YELLOW}Could not find download URL. Manual installation required:${NC}"
            echo "1. Visit: https://ghostty.org/"
            echo "2. Download the .dmg file" 
            echo "3. Open the .dmg and drag Ghostty to Applications folder"
        fi
        
        cd - > /dev/null
        rm -rf "$TEMP_DIR"
    fi
else
    success "Ghostty already installed"
fi

# Step 4: Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    status "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "Oh My Zsh installed"
else
    success "Oh My Zsh already installed"
fi

# Step 5: Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    status "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    success "Powerlevel10k installed"
else
    success "Powerlevel10k already installed"
fi

# Step 6: Install Zsh plugins
status "Installing Zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Auto-suggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# Syntax highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Completions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions \
        $ZSH_CUSTOM/plugins/zsh-completions
fi

# History substring search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search \
        $ZSH_CUSTOM/plugins/zsh-history-substring-search
fi

success "Zsh plugins installed"

# Step 7: Install Oh My Tmux
if [ ! -d "$HOME/.tmux" ]; then
    status "Installing Oh My Tmux..."
    cd $HOME
    git clone --single-branch https://github.com/gpakosz/.tmux.git
    ln -sf .tmux/.tmux.conf
    cd - > /dev/null
    success "Oh My Tmux installed"
else
    success "Oh My Tmux already installed"
fi

# Step 8: Create configuration files
status "Setting up configuration files..."

# Create .zshrc
backup_existing_config ~/.zshrc
cat > ~/.zshrc << 'ZSHRC'
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

# ZSH Auto-suggestions Configuration - ENHANCED PREDICTIONS
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7a7a7a,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# Accept auto-suggestion with right arrow
bindkey '→' autosuggest-accept
bindkey '^[[C' autosuggest-accept  # Right arrow
bindkey '^I' complete-word         # Tab for completion
bindkey '^[[Z' autosuggest-accept  # Shift+Tab to accept suggestion

# Better history search with substring search plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

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
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

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

# Custom functions

# rl: Get absolute file path and copy to clipboard
function rl() {
  local file="$1"
  if [[ -z "$file" ]]; then
    echo "Usage: rl <file>"
    return 1
  fi
  local abs_path=$(realpath "$file" 2>/dev/null || echo "$PWD/$file")
  echo "$abs_path" | pbcopy
  echo "Copied to clipboard: $abs_path"
}

# Auto cd + ls function (enhanced with eza)
function chpwd() {
  eza --icons
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC

# Create Ghostty config directory and config file
mkdir -p ~/.config/ghostty
backup_existing_config ~/.config/ghostty/config
cat > ~/.config/ghostty/config << 'GHOSTTY'
# Claude Code Ultimate Ghostty Configuration

# Font
font-family = "MesloLGS Nerd Font"
font-size = 16

# Appearance
theme = tokyo-night
window-decoration = false
window-padding-x = 10
window-padding-y = 10
background-opacity = 0.95
macos-window-shadow = true

# Colors (Tokyo Night theme)
foreground = c0caf5
background = 1a1b26
cursor-color = c0caf5
selection-foreground = c0caf5
selection-background = 33467c

# ANSI colors
palette = 0=#15161e
palette = 1=#f7768e
palette = 2=#9ece6a
palette = 3=#e0af68
palette = 4=#7aa2f7
palette = 5=#bb9af7
palette = 6=#7dcfff
palette = 7=#a9b1d6
palette = 8=#414868
palette = 9=#f7768e
palette = 10=#9ece6a
palette = 11=#e0af68
palette = 12=#7aa2f7
palette = 13=#bb9af7
palette = 14=#7dcfff
palette = 15=#c0caf5

# Terminal
scrollback-limit = 10000
confirm-close-surface = false

# Key bindings for natural text editing
keybind = alt+left=text:\x1b[1;5D
keybind = alt+right=text:\x1b[1;5C
keybind = cmd+left=text:\x01
keybind = cmd+right=text:\x05
keybind = alt+backspace=text:\x17
keybind = cmd+backspace=text:\x15
GHOSTTY

# Create .tmux.conf.local
backup_existing_config ~/.tmux.conf.local
cat > ~/.tmux.conf.local << 'TMUX'
# General settings
set -g history-limit 50000
set -g mouse on
set -g set-clipboard on
set -g mode-keys vi

# Change prefix to Ctrl-a
set -gu prefix2
unbind C-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Faster escape time for vim
set -g escape-time 10

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set-option -g renumber-windows on

# Pane splits
bind | split-window -h -c '#{pane_current_path}' #!important
bind h split-window -h -c '#{pane_current_path}' #!important
bind - split-window -v -c '#{pane_current_path}' #!important
bind v split-window -v -c '#{pane_current_path}' #!important

# Reload config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!" #!important

# Easy navigation between panes
bind -n C-h select-pane -L #!important
bind -n C-j select-pane -D #!important
bind -n C-k select-pane -U #!important
bind -n C-l select-pane -R #!important

# Copy mode navigation
bind-key -T copy-mode-vi 'C-h' select-pane -L #!important
bind-key -T copy-mode-vi 'C-j' select-pane -D #!important
bind-key -T copy-mode-vi 'C-k' select-pane -U #!important
bind-key -T copy-mode-vi 'C-l' select-pane -R #!important

# Resize panes with H/J/K/L
bind -r H resize-pane -L 5 #!important
bind -r J resize-pane -D 5 #!important
bind -r K resize-pane -U 5 #!important
bind -r L resize-pane -R 5 #!important

# Alternative resize with u/i/o/p
bind u resize-pane -U 5 #!important
bind p resize-pane -D 5 #!important
bind i resize-pane -L 5 #!important
bind o resize-pane -R 5 #!important

# Maximize pane
bind m resize-pane -Z #!important

# Copy mode vim bindings
bind -T copy-mode-vi v send-keys -X begin-selection #!important
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel #!important

# Double click to select word
set -g word-separators ""
bind-key -n DoubleClick1Pane \
    select-pane \; \
    copy-mode -M \; \
    send-keys -X select-word \; \
    run-shell "sleep .4s" \; \
    send-keys -X copy-selection-and-cancel #!important

# Quick Claude Code launchers
bind C new-window -n "Claude Code" "claude code" #!important
bind V split-window -h "claude code" #!important
bind S split-window -v "claude code" #!important

# Settings
tmux_conf_new_window_retain_current_path=true
tmux_conf_new_pane_retain_current_path=true

# Use current shell
set-option -g default-shell "${SHELL}"
set -g default-command "${SHELL}"

# Terminal settings for proper colors
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",xterm-256color*:Tc"

# Theme colors (Tokyo Night)
tmux_conf_theme_colour_1="#15161e"
tmux_conf_theme_colour_2="#1a1b26"
tmux_conf_theme_colour_3="#565f89"
tmux_conf_theme_colour_4="#7aa2f7"
tmux_conf_theme_colour_5="#e0af68"
tmux_conf_theme_colour_6="#15161e"
tmux_conf_theme_colour_7="#c0caf5"

# Enable clipboard
tmux_conf_copy_to_os_clipboard=true

# Sane scrolling
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
TMUX

# Create minimal .p10k.zsh
backup_existing_config ~/.p10k.zsh
cat > ~/.p10k.zsh << 'P10K'
# Minimal Powerlevel10k config
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time)
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{cyan}❯%f '
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
P10K

# Create neovim configuration directory
mkdir -p ~/.config/nvim

# Create init.vim for neovim
cat > ~/.config/nvim/init.vim << 'NVIM'
" Basic Settings
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set tabstop=2                   " Tab width
set shiftwidth=2                " Indent width
set expandtab                   " Use spaces instead of tabs
set smartindent                 " Smart indenting
set wrap                        " Wrap lines
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive if uppercase
set termguicolors               " True color support
set scrolloff=8                 " Keep 8 lines above/below cursor
set signcolumn=yes              " Always show sign column
set updatetime=50               " Faster completion
set colorcolumn=80              " Show column at 80 characters
set clipboard=unnamedplus       " Use system clipboard
set mouse=a                     " Enable mouse

" Install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.config/nvim/plugged')

" Color scheme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" File explorer
Plug 'preservim/nerdtree'

" Status line
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Comment plugin
Plug 'tpope/vim-commentary'

" Tmux navigator
Plug 'christoomey/vim-tmux-navigator'

" Surround
Plug 'tpope/vim-surround'

call plug#end()

" Color scheme
colorscheme tokyonight-night

" Key mappings
let mapleader = " "

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize with arrows
nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Navigate buffers
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>

" Move text up and down
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" Better indenting
vnoremap < <gv
vnoremap > >gv

" Save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit with leader+q
nnoremap <leader>q :q<CR>

" Auto commands
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

" Lua configuration for plugins
lua << EOF
-- Lualine
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

-- Gitsigns
require('gitsigns').setup()

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "bash", "python", "javascript", "typescript", "rust", "go", "lua", "vim" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF
NVIM

success "Configuration files created"

# Step 9: Create quick launcher script
status "Creating Claude Code launcher script..."
cat > ~/cc-multi.sh << 'LAUNCHER'
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
LAUNCHER

chmod +x ~/cc-multi.sh
success "Launcher script created at ~/cc-multi.sh"

# Step 10: Verify FZF installation
status "Verifying FZF installation..."
if command -v fzf &> /dev/null; then
    success "FZF ready - modern shell integration configured in .zshrc"
else
    error "FZF not found - this should have been installed with brew install fzf"
fi

# Step 11: Change default shell if needed  
if [ "$SHELL" != "$(which zsh)" ]; then
    status "Changing default shell to zsh..."
    # Add zsh to allowed shells if not already there
    if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
        echo "$(which zsh)" | sudo tee -a /etc/shells > /dev/null
    fi
    # Change shell non-interactively
    sudo chsh -s "$(which zsh)" "$USER"
    success "Default shell changed to zsh"
else
    success "Zsh already default shell"
fi

# Done!
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next Steps (some automated):${NC}"

# Auto-open Applications folder if Ghostty was installed
if [ -d "/Applications/Ghostty.app" ]; then
    echo "1. ✓ Ghostty installed - ready to use"
    echo "2. Opening Ghostty now..."
    open -a Ghostty 2>/dev/null || echo "   (Please open Ghostty manually)"
else
    echo "1. Install Ghostty from https://ghostty.org/"
    echo "2. Open Ghostty (Cmd+Space, type 'ghostty')"
fi

echo "3. The Powerlevel10k wizard will start - choose your style"
echo "4. Run: nvim (first time will install plugins automatically)"
echo "5. Run: claude code /terminal-setup (for multi-line support)"

# Create a helper script for next steps
cat > ~/complete-setup.sh << 'HELPER'
#!/bin/bash
echo "=== Completing Claude Code Setup ==="
echo "1. Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa
echo "2. Testing Claude Code..."
claude code /terminal-setup
echo "3. Setup complete! You can delete this script: rm ~/complete-setup.sh"
HELPER

chmod +x ~/complete-setup.sh
echo ""
echo -e "${GREEN}💡 Helper script created: ~/complete-setup.sh${NC}"
echo -e "${GREEN}   Run this after opening Ghostty to complete setup automatically${NC}"
echo ""
echo -e "${YELLOW}Quick Start:${NC}"
echo "• Start tmux: tmux new -s main"
echo "• Split for new Claude Code: Ctrl+A |"
echo "• Navigate between panes: Ctrl+H/J/K/L"
echo "• Launch 4 instances at once: ~/cc-multi.sh"
echo "• Open neovim: nvim (or vim)"
echo ""
echo -e "${YELLOW}Key Shortcuts:${NC}"
echo "• tmux prefix: Ctrl+A"
echo "• neovim leader: Space"
echo "• File explorer in nvim: Space+e"
echo "• Find files in nvim: Space+f"
echo ""
echo -e "${YELLOW}FZF Power Features:${NC}"
echo "• Ctrl+T - Find files and directories (with preview)"
echo "• Ctrl+R - Search command history (with copy to clipboard)"
echo "• Alt+C - Navigate directories (with tree preview)"
echo "• Ctrl+Y - Copy command from history to clipboard"
echo "• Fuzzy completion: vim **<Tab>, cd **<Tab>, kill **<Tab>"
echo ""
echo -e "${YELLOW}Remember:${NC}"
echo "• 🔄 Log out and back in for FASTER KEYBOARD REPEAT"
echo "• 💡 Or manually: System Preferences > Keyboard > Set to fastest"
echo "• 🔌 First nvim launch installs plugins (be patient)"
echo ""
echo "Enjoy your multi-instance Claude Code setup with Ghostty and neovim! 🚀"