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


# Function to configure Python and Jupyter Lab
configure_python() {
    echo "🐍  Configuring Python and Jupyter Lab..."
    
    # Fetch the latest Python version information from the API
    echo "Fetching the latest Python version info from endoflife.date..."
    python_version_info=$(curl -s "https://endoflife.date/api/python.json" | jq -r '[.[] | select(.lts==false)] | max_by(.releaseDate) | .latest')

    if [[ -n "$python_version_info" && "$python_version_info" != "null" ]]; then
        echo "Latest Python version is $python_version_info. Starting installation..."   
    else
        echo "Failed to fetch the latest Python version information. Defaulting to latest 3.12"
        python_version_info="3.12"
        
    fi

    pyenv install $python_version_info
    echo "Python $python_version_info installed successfully."

    # Install virtualenv plugin for managing Python virtual environments
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv 1>/dev/null
    eval "$(pyenv init -)" 1>/dev/null
    eval "$(pyenv virtualenv-init -)" 1>/dev/null

    # Create a Python virtual environment named 'jupyter' and install Jupyter Lab
    pyenv virtualenv $python_version_info jupyter 1>/dev/null
    pyenv activate jupyter && python -m pip install --upgrade pip && pip install jupyterlab jupyter-dash 1>/dev/null
    pyenv global $python_version_info jupyter 1>/dev/null

    # add Python latest version to .zshrc
    # The file to be searched and updated
    FILE=$ZSHHOME/.zshrc
    # pyenv default python to latest statement
    PYENV_STATEMENT="pyenv shell ${python_version_info}"
    # Check if exists in the file
    if grep -q "^pyenv shell " "$FILE"; then
        # If it exists, update its value
        sed -i '' "s/^pyenv shell .*/${PYENV_STATEMENT}/" "$FILE"
        echo "Updated pyenv shell to ${python_version_info} in ${FILE}."
    else
        # If it does not exist, append it to the file
        echo "$PYENV_STATEMENT" >> "$FILE"
        echo "Added ${PYENV_STATEMENT} to ${FILE}."
    fi
}

# Function to install vim-plug for Neovim
install_vim_plug() {
    echo "👽  Installing vim-plug for Neovim..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

# Extra Setups
setup_utils(){
    echo "source $(brew --prefix autoenv)/activate.sh" >> ~/.zprofile
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
