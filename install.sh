#!/bin/bash

# A utility script to set up a new macOS environment

echo -e "\nInitializing macOS setup...\n"

# Ask for user inputs at the beginning
read -p "Would you like to set macOS preferences now? (y/N): " macos_preferences_confirm
read -p "Do you want to proceed with the Jupyter Lab setup? [y/N]: " jupyter_confirm

ZSHHOME=$HOME/dotfiles/zsh

# Function to create directories
create_dirs() {
    echo "🗄  Creating directories..."
    declare -a dirs=(
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
    echo "🛠  Installing Xcode Command Line Tools..."
    if ! xcode-select --print-path &>/dev/null; then
        xcode-select --install &>/dev/null

        until xcode-select --print-path &>/dev/null; do
            sleep 5
        done

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -license accept
    else
        echo "Xcode Command Line Tools already installed."
    fi
}

# Function to install Homebrew and packages
install_brew() {
    echo "🍺  Installing Homebrew and packages..."
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🍺 Updating Homebrew..."
    brew update
    echo "🍺 Installing packages..."
    brew bundle
}

# Function to set macOS preferences
set_macos_preferences() {
    if [[ "$macos_preferences_confirm" =~ ^[yY](es)?$ ]]; then
        echo "💻  Setting macOS preferences..."
        ./macos/.macos
    else
        echo "Skipping macOS preferences setup."
    fi
}

# Function to configure Node and Bun
configure_node() {
    echo "📦  Configuring Node..."
    npm install -g n 1>/dev/null
    curl -fsSL https://bun.sh/install | bash
    echo "🍞 baked bun -v$($HOME/.bun/bin/bun --version)"
}

# Function to configure Python
configure_python() {
    echo "🐍  Configuring Rye: Cargo for Python"
    if ! command -v rye &>/dev/null; then
        echo "Installing Rye"
        curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash
        source "$HOME/.rye/env"
        rye self completion -s zsh >>~/.zfunc/_rye
        rye config --set-bool behavior.global-python=true
        rye config --set-bool behavior.use-uv=true
    else
        echo "🍺 Updating Rye..."
        rye self update
    fi
}

# Function to setup Jupyter Lab environment
setup_jupyter_lab() {
    if [[ $jupyter_confirm == [yY] ]]; then
        echo "📚 Setting up Jupyter Lab environment in Codes/lab..."

        mkdir -p "$HOME/Codes/lab"
        cd "$HOME/Codes/lab"

        # Check if virtual environment directory exists
        if [ ! -d ".venv" ]; then
            echo "Creating virtual environment..."
            uv venv .venv
        fi

        # Activate the virtual environment
        source .venv/bin/activate

        # Check if Jupyter Lab is installed
        if ! pip freeze | grep jupyterlab &>/dev/null; then
            echo "Installing Jupyter Lab..."
            uv pip install jupyterlab jupyterlab-dash
        fi

        # Deactivate the virtual environment
        deactivate

        echo "Jupyter Lab setup complete! 🚀"
        echo "Use 'jupyterit' to start and 'jupyterkill' to stop Jupyter Lab."

        # back to dotfiles
        cd -
    else
        echo "Skipping Jupyter Lab setup."
    fi
}

# Function to install vim-plug for Neovim
install_vim_plug() {
    echo "👽  Installing vim-plug for Neovim..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # required
    rm -rf ~/.config/nvim
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git

    # remove default and use mine via link
    rm -rf ~/.config/nvim/lua
    # a symbolic link from nvim/lua to nvim/nvim/lua
    ln -s ~/.config/nvim/nvim/lua ~/.config/nvim/lua
}

# tmux plugin manager installation
tmux_if_not_exists() {
    local folder="$HOME/.tmux/plugins/tpm"
    local url="https://github.com/tmux-plugins/tpm"

    # Check if the directory exists, clone if not
    [ -d "$folder" ] || git clone $url $folder
}

# yazi thems installation
yazi_if_not_exists() {
    local folder="$HOME/.config/yazi/flavors"
    local url="https://github.com/yazi-rs/flavors.git"

    # Check if the directory exists, clone if not
    [ -d "$folder" ] || git clone $url $folder
}

# Extra Setups
setup_utils() {
    # auto source .envs
    echo "source $(brew --prefix autoenv)/activate.sh" >>~/.zprofile

    # install git large files
    git lfs install

    # productive laziness
    rye tools list | grep -q "^llm" || rye tools install llm
    llm --system 'Reply with linux terminal commands only, no extra information' --save cmd
}

create_virtualenvs() {
    echo "Creating Python Virtual Environments"
    # virtual environment directories and their respective packages
    envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
        "$HOME/.virtualenvs/debugpy|pynvim debugpy"
    )

    # create .virtualenvs directory if it doesn't exist
    mkdir -p "$HOME/.virtualenvs"

    # for each environment check existence and install
    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<<"$env"

        # create it if not exist
        if [ ! -d "$dir" ]; then
            python -m venv "$dir" &>/dev/null
        fi

        # upgrade pip and install the required packages
        "$dir/bin/pip" install --upgrade pip &>/dev/null
        "$dir/bin/pip" install --upgrade $packages &>/dev/null
    done

    echo "🔥 Virtual environments and 📦 packages installed."
}

# Function to use GNU Stow to manage dotfiles
stow_dotfiles() {
    echo "🐗  Stowing dotfiles..."
    stow alacritty fzf git nvim skhd starship tmux vim yabai zsh yazi
}

# Main setup sequence
create_dirs
install_xcode_tools
set_macos_preferences
install_brew
configure_node
configure_python
setup_jupyter_lab
create_virtualenvs
install_vim_plug
tmux_if_not_exists
yazi_if_not_exists
setup_utils
stow_dotfiles

echo "✨  Setup completed successfully!"
