# Aliases. Functions live in functions.zsh.
# GNU coreutils, findutils, sed, tar, grep and awk come first on PATH (see ~/.zshrc),
# so the plain names below run the GNU versions.

###############################################################################
# SHELL
###############################################################################

alias c="clear"  # Clear screen
alias x="exit"  # Exit shell
alias o="open ."  # Open current directory
alias t="touch"  # Create empty file
alias md="mkdir -p"  # Create directory
alias x+="chmod +x"  # Make executable
alias reload="exec zsh"  # Reload shell config
alias clip="pbcopy"  # Copy to clipboard
alias paste="pbpaste"  # Paste from clipboard
alias get="curl -fLO"  # Download file
alias update='"$DOTFILES_DIR/install.sh"'  # Run dotfiles installer

###############################################################################
# EDITORS
###############################################################################

alias v="nvim"  # Open Neovim
alias vi="nvim"  # Open Neovim
alias vim="nvim"  # Open Neovim
alias n="nvim"  # Open Neovim

###############################################################################
# MODERN CLI REPLACEMENTS
###############################################################################

alias cat="bat"  # View files with syntax highlighting
alias ls="eza --icons=always"  # List with icons
alias ll="eza -l"  # Long listing
alias la="eza -la"  # Long listing with hidden
alias tree="eza --tree"  # Tree view
alias top="btop"  # System monitor
alias du="ncdu"  # Disk usage analyzer

###############################################################################
# SAFER FILE OPERATIONS (verbose)
###############################################################################

alias cp="cp -v"  # Copy files (verbose)
alias mv="mv -v"  # Move files (verbose)
alias rm="rm -v"  # Remove files (verbose)
alias mkdir="mkdir -v"  # Create directories
alias rmdir="rmdir -v"  # Remove directories
alias chmod="chmod -v"  # Change permissions
alias chown="chown -v"  # Change ownership
alias chgrp="chgrp -v"  # Change group (verbose)
alias ln-sym="ln -nsf"  # Create symlinks
alias grep="grep --color=auto"  # Search with color

###############################################################################
# GIT
###############################################################################

alias g="git"  # Git command
alias ga="git add"  # Add file contents to index
alias gb="git branch"  # List/create branches
alias gf="git fetch"  # Download objects/refs
alias gg="git grep"  # Search patterns
alias gl="git log"  # Show commit logs
alias gm="git merge"  # Merge branches
alias gr="git remote"  # Manage remotes
alias gs="git status"  # Show status
alias gw="git log --raw --no-merges"  # Show change logs

# adding
alias gaa="git add ."  # Add all changes
alias gap="git add --patch"  # Interactively stage changes
alias gau="git add --update"  # Update tracked files

# branches
alias gbe="git branch --edit-description"  # Edit branch description
alias gbd="git branch -d"  # Delete branch
alias gbdd="git branch -D"  # Force delete branch
alias gch="git checkout"  # Switch branches
alias gcb="git checkout -b"  # Create and switch branch
alias gbm="git branch --merged"  # List merged branches
alias gbnm="git branch --no-merged"  # List unmerged branches

# cherry-pick
alias gchp="git cherry-pick"  # Apply commits

# commit
alias gc="git commit -am"  # Commit with message
alias gcm="git commit --amend --message"  # Amend last commit

# diff
alias gd="git diff"  # Show changes
alias gdt="git difftool"  # Diff with tool
alias gitfix='git diff --name-only | uniq | xargs "$EDITOR"'  # Open changed files

# grep
alias ggl="git grep --line-number"  # Search with line numbers
alias ggg="git grep --break --heading --line-number"  # Grep grouped by file

# log
alias glg="git log --graph"  # Log with graph
alias glo="git log --oneline"  # Compact log
alias changelog='git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short'  # Generate changelog

# merge
alias gmc="git merge --continue"  # Continue merge
alias gma="git merge --abort"  # Abort merge

# pull / push
alias gpl="git pull"  # Pull from remote
alias gp="git push"  # Push to remote
alias gpu="git push -u origin"  # Push and set upstream
alias undopush='git push --force-with-lease origin "HEAD^:$(git branch --show-current)"'  # Undo last push

# rebase
alias gre="git rebase"  # Rebase commits

# remote
alias gra="git remote add origin"  # Add remote

# stash
alias gst="git stash"  # Stash changes
alias gsa="git stash apply"  # Apply stash
alias gsp="git stash pop"  # Pop stash
alias gsd="git stash drop"  # Drop stash

# github
alias gbi="gh issue list --web"  # Open issues in the browser
alias gpr="gh pr create"  # Create a pull request

###############################################################################
# DIRECTORY NAVIGATION
###############################################################################

alias dev="cd ~/Codes"  # Development directory
alias desk="cd ~/Desktop"  # Desktop
alias docs="cd ~/Documents"  # Documents
alias dl="cd ~/Downloads"  # Downloads
alias home="cd ~"  # Home directory
alias dots='cd "$DOTFILES_DIR"'  # Dotfiles directory

###############################################################################
# PACKAGE MANAGERS
###############################################################################

# pnpm
alias pn="pnpm"  # PNPM command
alias pna="pnpm add"  # Add package
alias pnr="pnpm run"  # Run script
alias pni="pnpm install"  # Install packages

# python (uv)
alias pip="uv pip"  # Python packages (via uv)

###############################################################################
# TMUX
###############################################################################

alias iexit='tmux kill-session -t "$(tmux display-message -p "#S")"'  # Kill tmux session
alias ix="iexit"  # Kill tmux session (short)
alias ikill="tmux kill-server"  # Kill tmux server
alias ik="ikill"  # Kill tmux server (short)
alias iswitch="tmux choose-session"  # Switch tmux session
alias ipop='tmux display-popup -E "cd $(tmux display -p -F "#{pane_current_path}") && tmux new-session -A -s scratch"'  # Tmux popup

###############################################################################
# macOS
###############################################################################

# finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"  # Show hidden files
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"  # Hide hidden files
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"  # Show desktop icons
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"  # Hide desktop icons

# spotlight
alias spotoff="sudo mdutil -a -i off"  # Disable Spotlight
alias spoton="sudo mdutil -a -i on"  # Enable Spotlight

# system
alias afk="pmset displaysleepnow"  # Lock screen
alias stfu="osascript -e 'set volume output muted true'"  # Mute volume
alias restart="sudo reboot"  # Reboot system
alias bye="sudo shutdown -r now"  # Shutdown now

# cleanup
alias rm_ds="find . -name '*.DS_Store' -type f -ls -delete"  # Remove .DS_Store files
alias xcodepurge="rm -rf ~/Library/Developer/Xcode/DerivedData"  # Delete Xcode DerivedData
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"  # Kill Chrome renderer processes

###############################################################################
# FUNCTION SHORTCUTS
###############################################################################

alias tk="take"  # Create and enter (short)
alias clean="clean_pycache"  # Remove __pycache__
alias activate="activate_venv"  # Activate Python venv
alias pg="purge"  # Delete files matching a pattern
