# The Ultimate Guide to Running Multiple Claude Code Instances Like a Pro

## Transform Your Terminal into an AI-Powered Development Powerhouse

Ever wished you could have multiple AI assistants working on different parts of your project simultaneously? Imagine having one Claude Code instance refactoring your frontend, another writing tests, a third documenting your API, and a fourth researching best practices - all at the same time, in a beautiful, organized terminal setup.

This guide will take you from terminal novice to power user in about 15 minutes. By the end, you'll have a stunning terminal setup that makes running multiple Claude Code instances as easy as pressing a few keys.

## What You'll Get

Here's what your setup will look like:

1. **Multiple Claude Code Instances**: Run 2, 4, or even 8 AI assistants simultaneously
2. **Intelligent Auto-Predictions**: As you type commands, your terminal will predict what you want to type next (shown in gray text - just press → to accept!)
3. **Beautiful Modern Terminal**: A GPU-accelerated terminal with smooth animations and a gorgeous Tokyo Night theme
4. **Session Persistence**: Your Claude Code sessions survive terminal restarts - pick up exactly where you left off
5. **Lightning-Fast Navigation**: Jump between your AI assistants with simple keyboard shortcuts

## Prerequisites

All you need is:
- A Mac (macOS 14 or newer recommended)
- About 15 minutes
- Basic ability to copy and paste commands

That's it! No programming experience required.

## The Magic One-Line Installation

Open your current terminal (you can find it by pressing Cmd+Space and typing "Terminal"), then copy and paste this single command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jacquesthibodeau/cc-env-setup/main/install.sh)
```

Press Enter and watch the magic happen! The installer will:
- Set up all the tools you need
- Configure everything automatically
- Create shortcuts for launching multiple Claude Code instances
- Make your terminal beautiful and powerful

## Understanding Your New Superpowers

### The Auto-Suggestion Magic ✨

This is the feature that will blow your mind. As you start typing commands, your terminal will show predictions in gray text based on your command history and available options. 

**Try this:**
1. Type `cd ` (with a space after)
2. You'll see gray text suggesting directories you've visited before
3. Press the → arrow key to accept the suggestion
4. Or press Tab to see all possible options

The more you use your terminal, the smarter it gets!

### Your New Keyboard Shortcuts 🎹

Here are the essential shortcuts you'll use every day:

**For Auto-Suggestions:**
- `→` (Right Arrow) - Accept the gray suggestion
- `Ctrl+→` - Accept just one word
- `Tab` - Show completion menu
- `↑/↓` - Search through your command history
- `Esc` - Clear the current suggestion

**For Managing Multiple Claude Code Instances:**
- `Ctrl+A` - Your "prefix" key (press this first for most commands)
- `Ctrl+A |` - Split screen vertically (side by side)
- `Ctrl+A -` - Split screen horizontally (top and bottom)
- `Ctrl+H/J/K/L` - Navigate between Claude Code instances (no prefix needed!)
- `Ctrl+A m` - Maximize current pane (press again to restore)
- `Ctrl+A d` - Detach from session (it keeps running!)

**Quick Claude Code Launchers:**
- `cc` - Launch Claude Code
- `ccnew` - Split and launch new Claude Code
- `cc4` - Launch 4 Claude Code instances in a grid

## Your First Multi-Instance Session

Let's create your first multi-instance Claude Code setup:

### Method 1: The Quick 4-Instance Grid

Simply type:
```bash
cc4
```

Boom! You now have 4 Claude Code instances arranged in a perfect grid. Each can work on different tasks simultaneously.

### Method 2: Build Your Own Layout

1. Start tmux (your terminal multiplexer):
   ```bash
   tmux new -s myproject
   ```

2. Launch your first Claude Code:
   ```bash
   cc
   ```

3. Split the screen vertically (Ctrl+A, then |):
   - Press `Ctrl+A`
   - Release, then press `|`
   - Another Claude Code will launch automatically!

4. Navigate between them:
   - Press `Ctrl+H` to go left
   - Press `Ctrl+L` to go right
   - No need to press Ctrl+A first!

5. Add more instances:
   - Navigate to any pane
   - Press `Ctrl+A -` to split horizontally
   - Press `Ctrl+A |` to split vertically

## Real-World Workflows

### Workflow 1: Full-Stack Development
```
┌─────────────────┬─────────────────┐
│ Claude Code #1  │ Claude Code #2  │
│ Frontend Work   │ Backend API     │
├─────────────────┼─────────────────┤
│ Claude Code #3  │ Claude Code #4  │
│ Writing Tests   │ Documentation   │
└─────────────────┴─────────────────┘
```

Launch with `cc4`, then assign each instance a different task:
- Top-left: "Help me refactor my React components"
- Top-right: "Create REST API endpoints for user management"
- Bottom-left: "Write comprehensive tests for the auth module"
- Bottom-right: "Generate API documentation in OpenAPI format"

### Workflow 2: Code Review and Refactoring
1. Main pane: Claude Code reviewing your code
2. Right pane: Claude Code implementing suggested changes
3. Bottom pane: Claude Code writing tests for the changes

### Workflow 3: Learning and Experimentation
- Pane 1: Claude Code explaining concepts
- Pane 2: Claude Code writing example code
- Pane 3: Claude Code creating exercises
- Pane 4: Your regular terminal for running code

## Pro Tips for Maximum Productivity

### 1. Name Your Sessions
Instead of generic names, use descriptive session names:
```bash
tmux new -s frontend-refactor
tmux new -s api-development
tmux new -s bug-fixes
```

### 2. Quick Session Switching
List all sessions:
```bash
tmux ls
```

Attach to a specific session:
```bash
tmux attach -t frontend-refactor
```

### 3. Persistent Workspaces
Your tmux sessions survive terminal restarts! Close your terminal, come back tomorrow, and run:
```bash
tmux attach
```
All your Claude Code instances will be exactly where you left them.

### 4. The Power of History
The more commands you use, the better auto-suggestions become. After a week of use, you'll be flying through commands as your terminal predicts exactly what you want.

### 5. Quick Directory Navigation
After visiting directories a few times, jump to them instantly:
```bash
z myproject     # Jumps to ~/Documents/projects/myproject
z frontend      # Jumps to the most recent 'frontend' directory
```

## Troubleshooting Common Issues

### "The font doesn't look right"
Run this command:
```bash
p10k configure
```
Follow the wizard - it will help you set up the perfect look.

### "Auto-suggestions aren't working"
1. Restart your terminal completely
2. Type a command you've used before
3. Start typing it again - you should see gray text
4. If not, run: `exec zsh`

### "I accidentally closed my Claude Code sessions"
No worries! They're still running. Just type:
```bash
tmux attach
```

### "Keyboard shortcuts aren't working"
Remember:
- The prefix is `Ctrl+A` (not `Ctrl+B`)
- For splits: Press `Ctrl+A`, release, then press `|` or `-`
- For navigation: Just press `Ctrl+H/J/K/L` (no prefix needed)

## Customizing Your Setup

### Change the Color Theme
Edit `~/.wezterm.lua` and change this line:
```lua
config.color_scheme = 'Tokyo Night'
```
To any theme from [Wezterm's theme gallery](https://wezfurlong.org/wezterm/colorschemes/index.html).

### Adjust Font Size
In the same file, change:
```lua
config.font_size = 16.0
```

### Create Custom Shortcuts
Add to your `~/.zshrc`:
```bash
alias myproject="cd ~/Documents/myproject && cc4"
```

## The Complete Command Reference

### Essential Commands
- `cc` - Launch Claude Code
- `cc4` - Launch 4-instance grid
- `tmux new -s name` - Create named session
- `tmux attach` - Reattach to session
- `tmux ls` - List all sessions
- `exit` - Close current pane

### Navigation Commands
- `z dirname` - Jump to directory
- `Ctrl+T` - Fuzzy find files
- `Ctrl+R` - Search command history
- `ls` - List files (with beautiful icons!)
- `cat filename` - View file with syntax highlighting

### Pane Management
- `Ctrl+A |` - Split vertically
- `Ctrl+A -` - Split horizontally  
- `Ctrl+A x` - Close current pane
- `Ctrl+A z` - Zoom/unzoom pane
- `Ctrl+A Space` - Cycle through layouts

## What's Next?

Now that you have this powerful setup:

1. **Practice the Basics**: Spend 5 minutes creating and navigating between panes
2. **Build Muscle Memory**: Use the auto-suggestions for every command
3. **Create Your First Multi-Instance Project**: Try the 4-instance setup on a real project
4. **Customize**: Make it yours with themes and shortcuts
5. **Share**: Help others discover the power of multiple Claude Code instances

## Final Thoughts

Congratulations! You've just leveled up from terminal beginner to multi-instance Claude Code power user. Your new setup isn't just about running multiple AI assistants - it's about transforming how you work with AI-powered development.

Remember:
- **Auto-suggestions** learn from your habits - use them constantly
- **Sessions persist** - don't be afraid to close your terminal
- **Practice makes perfect** - the shortcuts will become second nature
- **Multiple instances** multiply your productivity

Welcome to the future of AI-assisted development. Now go build something amazing with your army of Claude Code assistants!

---

*Tip: Save this guide locally for reference:*
```bash
curl -o ~/Desktop/claude-code-guide.md https://raw.githubusercontent.com/jacquesthibodeau/cc-env-setup/main/BLOG_POST.md
```

## Manual Step-by-Step Setup (If One-Line Install Doesn't Work)

### Step 1: Install Homebrew (Package Manager)

Homebrew is like an app store for command-line tools. We'll use it to install everything else.

1. Open Terminal (press `Cmd+Space`, type "Terminal", press Enter)
2. Copy and paste this command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. Press Enter and follow the prompts (you'll need to enter your password)
4. After installation, you might see instructions to add Homebrew to your PATH. If so, run the commands it shows you.

### Step 2: Configure macOS for Better Productivity

Let's make your keyboard repeat faster so you can navigate code more quickly:

```bash
# Make keys repeat faster when held down
defaults write -g InitialKeyRepeat -float 10.0
defaults write -g KeyRepeat -float 1.0
```

**Note**: You'll need to log out and back in for these changes to take effect.

### Step 3: Install All Required Tools

Create a file with all the tools we need and install them at once:

```bash
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

### Step 4: Install Oh My Zsh and Plugins

```bash
# Install Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```

### Step 5: Install Oh My Tmux

```bash
cd ~
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -sf .tmux/.tmux.conf
cd -
```

### Step 6: Download and Apply Configuration Files

Get all the configuration files from the repository:

```bash
# Clone the setup repository
git clone https://github.com/jacquesthibodeau/cc-env-setup.git ~/cc-env-setup

# Copy configuration files
cp ~/cc-env-setup/configs/.zshrc ~/
cp ~/cc-env-setup/configs/.wezterm.lua ~/
cp ~/cc-env-setup/configs/.tmux.conf.local ~/
cp ~/cc-env-setup/configs/.p10k.zsh ~/
```

### Step 7: Set Up FZF and Change Default Shell

```bash
# Install FZF key bindings
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Change default shell to zsh
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
```

### Step 8: Create the Multi-Instance Launcher

```bash
# Create the cc4 launcher script
cat > ~/cc-multi.sh << 'EOF'
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
EOF

chmod +x ~/cc-multi.sh

# Create alias for cc4
echo "alias cc4='~/cc-multi.sh'" >> ~/.zshrc
```

### Step 9: Final Steps

1. **Close Terminal completely**
2. **Open Wezterm** (press Cmd+Space, type "wezterm", press Enter)
3. **Configure Powerlevel10k**: The configuration wizard will start automatically. Choose your preferred style.
4. **Set up Claude Code**: Run `claude code /terminal-setup` for multi-line support
5. **Log out and back in** for keyboard settings to take effect

That's it! You now have the same powerful setup as the one-line installer provides.