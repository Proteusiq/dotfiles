set -e

if type git > /dev/null; then
    if ! git clone https://github.com/proteusiq/dotfiles ~/dotfiles; then
        echo "Error: Failed to clone the repository using git."
        exit 1
    fi
else
    if ! curl -LO https://github.com/proteusiq/dotfiles/archive/master.zip; then
        echo "Error: Failed to download the repository using curl."
        exit 1
    fi
    if ! unzip master.zip; then
        echo "Error: Failed to unzip the downloaded file."
        exit 1
    fi
    rm -rf master.zip
    mv dotfiles-master ~/dotfiles
fi

chmod +x ~/dotfiles
cd ~/dotfiles

if ! ./install.sh; then
    echo "Error: Failed to execute the install script."
    exit 1
fi
