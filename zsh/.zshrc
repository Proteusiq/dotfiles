export PATH="/usr/local/sbin:$PATH"
export EDITOR=nvim

# uncomment to run zprof
# zmodload zsh/prof

# history
HISTSIZE=50000
SAVEHIST=10000

source ~/antigen.zsh

antigen bundles <<EOBUNDLES
    tmux
    command-not-found
    colored-man-pages

    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    djui/alias-tips
    zsh-users/zsh-syntax-highlighting
    proteusiq/auto-color-ls
EOBUNDLES
antigen apply

# set starship prompt
eval "$(starship init zsh)"

# load the rest of the configs
source $HOME/dotfiles/zsh/.exports
source $HOME/dotfiles/zsh/.aliases

# set pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell 3.12

# set poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit

# start tmux on open
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux

