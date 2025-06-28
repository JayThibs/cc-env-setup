# Changelog

## [1.0.0] - 2025-06-28

### Added
- **Multi-Instance Claude Code Setup**: Launch 2, 4, or 8 Claude Code instances in split panes
- **WezTerm Configuration**: GPU-accelerated terminal with Tokyo Night theme
- **Natural Text Editing**: iTerm2-style keybindings for word/line navigation
- **Enhanced Shell Experience**:
  - Zsh with Oh My Zsh framework
  - Powerlevel10k theme with icons
  - Auto-suggestions that learn from your history
  - Syntax highlighting in the terminal
  - Substring history search
  - Fuzzy finding with fzf
- **Productivity Features**:
  - `rl` command to copy absolute file paths to clipboard
  - Automatic directory listing when changing directories
  - Optimized keyboard repeat rates (10ms initial, 1ms repeat)
- **tmux Integration**:
  - Persistent sessions that survive terminal restarts
  - Intuitive keybindings with Ctrl+A prefix
  - Oh My Tmux configuration
- **Neovim Setup**:
  - Tokyo Night theme matching terminal
  - Automatic vim-plug installation
  - Essential plugins pre-configured
  - TreeSitter syntax highlighting
- **Advanced Workflows**:
  - Documentation for AI teams with git worktrees
  - Self-spawning agent patterns
  - Task management strategies
- **Comprehensive Documentation**:
  - Beginner-friendly blog post
  - Technical setup guide
  - Resource links to all tools

### Features
- One-line installer that configures everything automatically
- Cross-session history with unlimited size
- GPU-accelerated rendering in WezTerm
- Session restoration after system restarts
- Natural text editing matching iTerm2's preset
- Complete Claude Code integration with shortcuts

### Technical Details
- Homebrew package management
- Automatic error handling and recovery
- macOS-optimized keyboard settings
- System clipboard integration
- Mouse support in terminal and vim