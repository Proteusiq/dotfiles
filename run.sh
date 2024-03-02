if type git > /dev/null; then
    git clone https://github.com/proteusiq/dotfiles ~/dotfiles
    chmod +x ~/dotfiles
    cd ~/dotfiles
    ./install.sh
else
    curl -LO https://github.com/proteusiq/dotfiles/archive/master.zip
    unzip master.zip
    rm -rf master.zip
    mv dotfiles-master ~/dotfiles
    chmod +x ~/dotfiles
    cd ~/dotfiles
    ./install.sh
fi