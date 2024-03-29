#!/bin/bash

# A utility script to set up a new macOS environment

echo -e "\nInitializing macOS setup...\n"

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
    if ! xcode-select --print-path &> /dev/null; then
        xcode-select --install &> /dev/null

        until xcode-select --print-path &> /dev/null; do
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
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "🍺 Updating Homebrew..."
    brew update
    echo "🍺 Installing packages..."
    brew bundle
}

# Function to set macOS preferences
set_macos_preferences() {
    echo "💻  Setting macOS preferences..."
    ./macos/.macos
}

# Function to configure Node
configure_node() {
    echo "📦  Configuring Node..."
    npm install -g n 1>/dev/null
}


# Function to configure Python
configure_python() {
    echo "🐍  Configuring Rye: Cargo for Python"
    if ! command -v rye &> /dev/null; then
        echo "Installing Rye"
        curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes"  bash
        source "$HOME/.rye/env"
        rye self completion -s zsh >> ~/.zfunc/_rye
        rye config --set-bool behavior.global-python=true
        rye config --set-bool behavior.use-uv=true

    else

        echo "🍺 Updating Rye..."
        rye self update
    fi
    
    }

# Function to setup Jupyter Lab environment
setup_jupyter_lab() {
    echo "📚 Setting up Jupyter Lab environment in Codes/lab..."

    # Confirmation prompt
    read -p "Do you want to proceed with the setup? [y/N]: " confirm && [[ $confirm == [yY] ]] || return 1

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
    if ! pip freeze | grep jupyterlab &> /dev/null; then
        echo "Installing Jupyter Lab..."
        uv pip install jupyterlab jupyterlab-dash
    fi
    
    # Deactivate the virtual environment
    deactivate

    echo "Jupyter Lab setup complete! 🚀"
    echo "Use 'jupyterit' to start and 'jupyterkill' to stop Jupyter Lab."
    
    # back to dotfiles
    cd $HOME/dotfiles
}


# Function to install vim-plug for Neovim
install_vim_plug() {
    echo "👽  Installing vim-plug for Neovim..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

# Extra Setups
setup_utils(){
    # auto source .envs
    echo "source $(brew --prefix autoenv)/activate.sh" >> ~/.zprofile

    # install git large files
    git lfs install

}

# Function to use GNU Stow to manage dotfiles
stow_dotfiles() {
    echo "🐗  Stowing dotfiles..."
    stow alacritty fzf git nvim skhd starship tmux vim yabai zsh
}

# Main setup sequence
create_dirs
install_xcode_tools
install_brew
configure_node
configure_python
setup_jupyter_lab
install_vim_plug
setup_utils
stow_dotfiles

# Optional macOS preferences setup
read -p "Would you like to set macOS preferences now? (y/N): " response
if [[ "$response" =~ ^[yY](es)?$ ]]; then
    set_macos_preferences
else
    echo "Skipping macOS preferences setup."
fi

echo "✨  Setup completed successfully!"
