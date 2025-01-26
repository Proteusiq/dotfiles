#!/bin/bash

# A utility script to set up a new macOS environment

set -euo pipefail

echo -e "\n🐌 The World Changed! Beginning MacOS setup...\n"

# Ask for user inputs at the beginning
read -r -p "  Would you like to set macOS preferences now? (y/N): " macos_preferences_confirm

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

# Function to set macOS preferences
set_macos_preferences() {
    if [[ "$macos_preferences_confirm" =~ ^[yY](es)?$ ]]; then
        echo "  Setting macOS preferences..."
        source "$HOME/dotfiles/macos/.macos"
    else
        echo "  Skipping macOS preferences setup."
    fi
}

# Function to configure Node and Bun
configure_node() {
    echo "📦 Configuring Node..."
    npm install -g n &>/dev/null
    curl -fsSL https://bun.sh/install | bash
    echo "🍞 Baked bun -v$($HOME/.bun/bin/bun --version)"
}

# Function to setup Jupyter Lab environment
setup_jupyter_lab() {
    echo "🪐 Setting up Jupyter Lab environment in Codes/lab..."

    mkdir -p "$HOME/Codes/lab"
    cd "$HOME/Codes/lab"

    # Check if virtual environment directory exists
    if [ ! -d ".venv" ]; then
        echo "🪐 Creating virtual environment..."
        uv venv
    fi

    # Activate the virtual environment
    source .venv/bin/activate

    # Check if Jupyter Lab is installed
    if ! uv pip freeze | grep jupyterlab &>/dev/null; then
        echo "🪐 Installing Jupyter Lab..."
        uv pip install jupyterlab jupyterlab-dash
    else
        echo "🪐 Jupyter Lab is already installed. Upgrading..."
        uv pip install --upgrade jupyterlab jupyterlab-dash
    fi

    # Deactivate the virtual environment
    deactivate

    echo "🪐 Jupyter Lab setup complete! 🚀"
    echo "🪐 Use 'jupyterit' to start and 'jupyterkill' to stop Jupyter Lab."

    # Back to the original directory
    cd - || exit
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

    # Aliases help
    chmod +x "$ZSHHOME/.alias_help.sh"

    # Install git large files
    git lfs install

    # Productive laziness
    # LLM
    uv tool list | grep -q "llm" && uv tool upgrade llm || uv tool install llm
    export PATH="$HOME/.local/bin:$PATH"
    llm --system 'Reply with linux terminal commands only, no extra information' --save cmd
    llm --system 'Reply with neovim commands only, no extra infromation' --save nvim
    

    # Aider and Posting
    # Aider

    uv tool list | grep -q "aider" && uv tool upgrade aider-chat || uv tool install aider-chat --python 3.11
    uv tool list | grep -q "posting" && uv tool upgrade posting || uv tool install posting --python 3.11

        # Add Claude and Ollama
    llm  install llm-claude-3 llm-ollama &>/dev/null;
    
    # Set Claude as defult
    llm models default claude-3-5-sonnet-latest

    # better scripts
    rgr --version | grep -q "repgrep" || cargo install repgrep
    [! -f $HOME/.rgrc] && touch $HOME/.rgrc

    

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
set_macos_preferences
install_brew
configure_node
setup_jupyter_lab
create_virtualenvs
install_tmux_plugins
install_yazi_themes
setup_utils
stow_dotfiles

echo "🦊  The World is restored. Setup completed successfully!"
