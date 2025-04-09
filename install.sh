#!/bin/bash

# A utility script to set up a new macOS environment

set -euo pipefail

echo -e "\n🐌 The World Changed! Beginning MacOS setup...\n"

ZSHHOME="$HOME/dotfiles/zsh"

# Function to create directories
create_dirs() {
    echo "🗄 Creating directories..."
    local dirs=(
        "$HOME/Codes"
        "$HOME/Documents/Screenshots"
        "$HOME/Downloads/Torrents"
    )
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        echo "Created $dir"
    done
}

# Function to install Xcode Command Line Tools
install_xcode_tools() {
    echo "🛠 Installing Xcode Command Line Tools..."
    if ! xcode-select --print-path &>/dev/null; then
        xcode-select --install &>/dev/null

        until xcode-select --print-path &>/dev/null; do
            sleep 5
        done

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -license accept
    else
        echo "🩻 Xcode Command Line Tools already installed."
    fi
}

# Function to install Homebrew and packages
install_brew() {
    echo "🍺 Installing Homebrew and packages..."
    if ! command -v brew &>/dev/null; then
        export HOMEBREW_NO_INSTALL_FROM_API=1
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🍺 Updating Homebrew..."
    brew update --force
    echo "🍺 Installing packages..."
    brew bundle --file="$HOME/dotfiles/Brewfile"
}


# Function to configure Node and Bun
configure_node() {
    echo "📦 Configuring Node..."
    npm install -g n &>/dev/null
    curl -fsSL https://bun.sh/install | bash
    echo "🍞 Baked bun -v$($HOME/.bun/bin/bun --version)"
}

# Function to install tmux plugin manager
install_tmux_plugins() {
    local folder="$HOME/.tmux/plugins/tpm"
    local url="https://github.com/tmux-plugins/tpm"

    [ -d "$folder" ] || git clone "$url" "$folder"
}

# Function to install Yazi themes
install_yazi_themes() {
    local folder="$HOME/.config/yazi/flavors"
    local url="https://github.com/yazi-rs/flavors.git"

    [ -d "$folder" ] || git clone "$url" "$folder"
}

# Function for additional setups
setup_utils() {

    # Install git large files
    git lfs install

    # Productive laziness
    # Goose
    curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash

    # LLM
    uv tool list | grep -q "llm" && uv tool upgrade llm || uv tool install llm
    export PATH="$HOME/.local/bin:$PATH"
    llm --system 'Reply with linux terminal commands only, no extra information' --save cmd
    llm --system 'Reply with neovim commands only, no extra infromation' --save nvim

    # Aider + Ra-Aid and Posting

    uv tool list | grep -q "aider" && uv tool upgrade aider-chat || uv tool install aider-chat --python 3.11
    uv tool list | grep -q "posting" && uv tool upgrade posting || uv tool install posting --python 3.11
     uv tool list | grep -q "ra-aid" && uv tool upgrade ra-aid || uv tool install ra-aid --python 3.11
    
    # Add Claude and Ollama
    llm install llm-anthropic llm-ollama &>/dev/null

    # Set Claude as defult
    llm models default claude-3.5-sonnet-latest

    # better scripts
    rgr --version | grep -q "repgrep" || cargo install repgrep
    [ -f "$HOME/.rgrc" ] || touch "$HOME/.rgrc"

    # custom scripts

    for file in $HOME/dotfiles/bin/*.py; do
        cp "$file" "$HOME/.local/bin/$(basename "${file%.py}")"
    done

}

# Function to create Python virtual environments
create_virtualenvs() {
    echo "🐍  Creating Python Virtual Environments..."
    local envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
        "$HOME/.virtualenvs/debugpy|pynvim debugpy ruff"
    )

    mkdir -p "$HOME/.virtualenvs"

    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<<"$env"
        if [ ! -d "$dir" ]; then
            uv venv "$dir" &>/dev/null
        fi

        source $dir/bin/activate
        uv pip install --upgrade $packages #&>/dev/null
        deactivate
    done

    echo "🔥  Virtual environments and 📦 packages installed."
}

# Function to use GNU Stow to manage dotfiles
stow_dotfiles() {
    echo "🐗  Stowing dotfiles..."
    stow --adopt -d "$HOME/dotfiles" -t "$HOME" fzf git ghostty nvim sesh starship tmux vim zsh yazi aerospace
}

# Main setup sequence
create_dirs
install_xcode_tools
install_brew
configure_node
create_virtualenvs
install_tmux_plugins
install_yazi_themes
setup_utils
stow_dotfiles

echo "🦊  The World is restored. Setup completed successfully!"
