#!/bin/bash

install_brew() {
    if ! command -v "brew" &> /dev/null; then
        printf "Homebrew not found, installing."
        # install homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    fi

    
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    printf "Homebrew version"
    brew --version
    

    printf "Installing homebrew packages..."
    brew bundle

    
}

create_dirs() {
    declare -a dirs=(
        "$HOME/Codes"
        "$HOME/Documents/Screenshots"
        "$HOME/Downloads/Torrents"
    )

    for i in "${dirs[@]}"; do
        mkdir -p "$i"
    done
}

build_xcode() {
    if ! xcode-select --print-path &> /dev/null; then
        xcode-select --install &> /dev/null

        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer

        sudo xcodebuild -license
    fi
}


printf "🗄  Creating directories\n"
create_dirs

printf "🛠  Installing Xcode Command Line Tools\n"
build_xcode

printf "🍺  Installing Homebrew packages\n"
install_brew


printf "💻  Set macOS preferences\n"
./macos/.macos

printf "📦  Configure Node\n"
# install n for version management
npm install -g n 1>/dev/null

printf "🐍  Configure Python\n"
# setup pyenv / global python to latest # TODO make it take latest python
pyenv install 3.12 1>/dev/null
pyenv global 3.12 1>/dev/null

# get the virtualenv plugin
/bin/bash -c "git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv" 1>/dev/null
eval "$(pyenv init -)" 1>/dev/null
eval "$(pyenv virtualenv-init -)" 1>/dev/null


printf "🐍  Configure Jupyter Lab\n"
# setup reusable jupyter lab
pyenv virtualenv 3.12 jupyter 1>/dev/null
pyenv activate jupyter && python -m pip install --upgrade pip && pip install jupyterlab 1>/dev/null
# order the priority
pyenv global jupyter 1>/dev/null


printf "👽  Installing vim-plug\n"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

printf "🐗  Stow dotfiles\n"
stow alacritty fzf git nvim skhd starship tmux vim yabai zsh

printf "✨  Done!\n"
