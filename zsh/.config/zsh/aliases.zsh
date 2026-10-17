# Aliases. Functions live in functions.zsh.
# GNU coreutils, findutils, sed, tar, grep and awk come first on PATH (see ~/.zshrc),
# so the plain names below run the GNU versions.

###############################################################################
# SHELL
###############################################################################

alias c="clear"
alias x="exit"
alias o="open ."
alias t="touch"
alias md="mkdir -p"
alias x+="chmod +x"
alias reload="exec zsh"
alias clip="pbcopy"
alias paste="pbpaste"
alias get="curl -fLO"
alias update='"$DOTFILES_DIR/install.sh"'

###############################################################################
# EDITORS
###############################################################################

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias n="nvim"

###############################################################################
# MODERN CLI REPLACEMENTS
###############################################################################

alias cat="bat"
alias ls="eza --icons=always"
alias ll="eza -l"
alias la="eza -la"
alias tree="eza --tree"
alias top="btop"
alias du="ncdu"

###############################################################################
# SAFER FILE OPERATIONS (verbose)
###############################################################################

alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias mkdir="mkdir -v"
alias rmdir="rmdir -v"
alias chmod="chmod -v"
alias chown="chown -v"
alias chgrp="chgrp -v"
alias ln-sym="ln -nsf"
alias grep="grep --color=auto"

###############################################################################
# GIT
###############################################################################

alias g="git"
alias ga="git add"
alias gb="git branch"
alias gf="git fetch"
alias gg="git grep"
alias gl="git log"
alias gm="git merge"
alias gr="git remote"
alias gs="git status"
alias gw="git log --raw --no-merges"

# adding
alias gaa="git add ."
alias gap="git add --patch"
alias gau="git add --update"

# branches
alias gbe="git branch --edit-description"
alias gbd="git branch -d"
alias gbdd="git branch -D"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gbm="git branch --merged"
alias gbnm="git branch --no-merged"

# cherry-pick
alias gchp="git cherry-pick"

# commit
alias gc="git commit -am"
alias gcm="git commit --amend --message"

# diff
alias gd="git diff"
alias gdt="git difftool"
alias gitfix='git diff --name-only | uniq | xargs "$EDITOR"'

# grep
alias ggl="git grep --line-number"
alias ggg="git grep --break --heading --line-number"

# log
alias glg="git log --graph"
alias glo="git log --oneline"
alias changelog='git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short'

# merge
alias gmc="git merge --continue"
alias gma="git merge --abort"

# pull / push
alias gpl="git pull"
alias gp="git push"
alias gpu="git push -u origin"
alias undopush='git push --force-with-lease origin "HEAD^:$(git branch --show-current)"'

# rebase
alias gre="git rebase"

# remote
alias gra="git remote add origin"

# stash
alias gst="git stash"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias gsd="git stash drop"

# github
alias gbi="gh issue list --web"
alias gpr="gh pr create"

###############################################################################
# DIRECTORY NAVIGATION
###############################################################################

alias dev="cd ~/Codes"
alias desk="cd ~/Desktop"
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"
alias home="cd ~"
alias dots='cd "$DOTFILES_DIR"'

###############################################################################
# PACKAGE MANAGERS
###############################################################################

# pnpm
alias pn="pnpm"
alias pna="pnpm add"
alias pnr="pnpm run"
alias pni="pnpm install"

# python (uv)
alias pip="uv pip"

###############################################################################
# TMUX
###############################################################################

alias iexit='tmux kill-session -t "$(tmux display-message -p "#S")"'
alias ix="iexit"
alias ikill="tmux kill-server"
alias ik="ikill"
alias iswitch="tmux choose-session"
alias ipop='tmux display-popup -E "cd $(tmux display -p -F "#{pane_current_path}") && tmux new-session -A -s scratch"'

###############################################################################
# macOS
###############################################################################

# finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# spotlight
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# system
alias afk="pmset displaysleepnow"
alias stfu="osascript -e 'set volume output muted true'"
alias restart="sudo reboot"
alias bye="sudo shutdown -r now"

# cleanup
alias rm_ds="find . -name '*.DS_Store' -type f -ls -delete"
alias xcodepurge="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

###############################################################################
# FUNCTION SHORTCUTS
###############################################################################

alias tk="take"
alias clean="clean_pycache"
alias activate="activate_venv"
alias pg="purge"
