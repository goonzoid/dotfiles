#!/usr/bin/env bash

set -e -u

sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt update
sudo apt install -y git stow zsh fd-find tmux vim python3-pip
chsh -s "$(command -v zsh)"
mkdir -p ~/.local/bin
ln -f -s "$(command -v fdfind)" ~/.local/bin/fd
pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl

./install_or_update.sh
