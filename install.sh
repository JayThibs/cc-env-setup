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

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Claude Code Multi-Instance Terminal Setup Installer       ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print status
status() {
    echo -e "${BLUE}==>${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

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

# Step 1: Install Homebrew if needed
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
success "Keyboard configured for faster repeat"

# Step 3: Install all packages at once
status "Installing terminal tools (this may take a few minutes)..."
brew bundle --no-lock --file=/dev/stdin <<EOF
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

# Neovim
brew "neovim"

# Applications
cask "wezterm"
cask "font-meslo-lg-nerd-font"
EOF

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

# History
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
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Aliases
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cd="z"
alias cat="bat"
alias vim="nvim"

# Claude Code helpers
alias cc="claude code"
alias ccnew="tmux split-window -h 'claude code'"
alias ccvsplit="tmux split-window -h 'claude code'"
alias cchsplit="tmux split-window -v 'claude code'"
alias cc4="~/cc-multi.sh"

# Initialize tools
eval "$(zoxide init zsh)"
source <(fzf --zsh)

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

# Auto cd + ls function
function chpwd() {
  ls
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC

# Create .wezterm.lua
cat > ~/.wezterm.lua << 'WEZTERM'
-- Claude Code Ultimate Wezterm Configuration

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font configuration
config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 16.0

-- Window configuration
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

-- Colors
config.color_scheme = 'Tokyo Night'

-- Custom color scheme (matches Powerlevel10k)
config.colors = {
  -- Foreground and background
  foreground = '#c0caf5',
  background = '#1a1b26',
  
  -- Cursor
  cursor_bg = '#c0caf5',
  cursor_fg = '#1a1b26',
  cursor_border = '#c0caf5',
  
  -- Selection
  selection_fg = '#c0caf5',
  selection_bg = '#33467c',
  
  -- Normal colors
  ansi = {
    '#15161e', -- black
    '#f7768e', -- red
    '#9ece6a', -- green
    '#e0af68', -- yellow
    '#7aa2f7', -- blue
    '#bb9af7', -- magenta
    '#7dcfff', -- cyan
    '#a9b1d6', -- white
  },
  
  -- Bright colors
  brights = {
    '#414868', -- bright black
    '#f7768e', -- bright red
    '#9ece6a', -- bright green
    '#e0af68', -- bright yellow
    '#7aa2f7', -- bright blue
    '#bb9af7', -- bright magenta
    '#7dcfff', -- bright cyan
    '#c0caf5', -- bright white
  },
  
  -- Tab bar
  tab_bar = {
    background = '#15161e',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
    },
    inactive_tab = {
      bg_color = '#1a1b26',
      fg_color = '#545c7e',
    },
    inactive_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#7aa2f7',
    },
    new_tab = {
      bg_color = '#1a1b26',
      fg_color = '#7aa2f7',
    },
    new_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#7aa2f7',
    },
  },
}

-- Key bindings
config.keys = {
  -- Natural Text Editing (like iTerm2's Natural Text Editing preset)
  -- Word navigation
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'b', mods = 'ALT' },
  },
  {
    key = 'RightArrow', 
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
  },
  
  -- Line navigation
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
  {
    key = 'RightArrow',
    mods = 'CMD', 
    action = wezterm.action.SendKey { key = 'e', mods = 'CTRL' },
  },
  
  -- Delete word
  {
    key = 'Backspace',
    mods = 'OPT',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },
  
  -- Delete line
  {
    key = 'Backspace',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'u', mods = 'CTRL' },
  },
  
  -- Split panes
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  
  -- Navigate panes
  {
    key = 'h',
    mods = 'CMD|ALT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CMD|ALT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CMD|ALT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CMD|ALT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  
  -- Resize panes
  {
    key = 'h',
    mods = 'CMD|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'l',
    mods = 'CMD|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'k',
    mods = 'CMD|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'j',
    mods = 'CMD|SHIFT|ALT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
  
  -- Close pane
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  
  -- Toggle full screen
  {
    key = 'Enter',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ToggleFullScreen,
  },
  
  -- Copy/Paste
  {
    key = 'c',
    mods = 'CMD',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'CMD',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  
  -- Clear scrollback
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  
  -- Search
  {
    key = 'f',
    mods = 'CMD',
    action = wezterm.action.Search 'CurrentSelectionOrEmptyString',
  },
}

-- Mouse bindings
config.mouse_bindings = {
  -- Right click paste
  {
    event = { Down = { streak = 1, button = 'Right' } },
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  
  -- Change font size with Ctrl+Scroll
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
}

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}

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
WEZTERM

# Create .tmux.conf.local
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

# Step 10: Set up FZF
status "Setting up FZF key bindings..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true

# Step 11: Change default shell if needed
if [ "$SHELL" != "$(which zsh)" ]; then
    status "Changing default shell to zsh..."
    sudo sh -c "echo $(which zsh) >> /etc/shells" 2>/dev/null || true
    chsh -s $(which zsh) 2>/dev/null || true
fi

# Done!
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Close this terminal completely"
echo "2. Open Wezterm (Cmd+Space, type 'wezterm')"
echo "3. The Powerlevel10k wizard will start - choose your style"
echo "4. Run: nvim (first time will install plugins automatically)"
echo "5. Run: claude code /terminal-setup (for multi-line support)"
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
echo -e "${YELLOW}Remember:${NC}"
echo "• Log out and back in for keyboard settings"
echo "• First nvim launch installs plugins (be patient)"
echo ""
echo "Enjoy your multi-instance Claude Code setup with neovim! 🚀"