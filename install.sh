#!/usr/bin/env bash

set -e -u

OS=$(uname)
if [[ $OS == 'Darwin' ]]; then
    if ! [ -x "$(command -v brew)" ]; then
        echo "brew not found, install homebrew and try again"
        exit 1
    fi
    brew tap homebrew/bundle && brew bundle
elif [[ $OS == 'Linux' ]]; then
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt update
    sudo apt install -y git stow zsh fd-find tmux vim python3-pip
    ln -f -s "$(command -v fdfind)" ~/.local/bin/fd
    pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl
else
    echo "Unknown OS: $OS"
    exit 1
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone git@github.com:tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -d ~/.config/base16-shell ]]; then
    git clone git@github.com:chriskempson/base16-shell ~/.config/base16-shell
fi

if [[ ! -d ~/.fzf ]]; then
    git clone git@github.com:junegunn/fzf ~/.fzf
    ~/.fzf/install --bin
fi

stow -t ~ zsh
chsh -s "$(command -v zsh)"

stow -t ~ git

stow -t ~ tmux

stow -t ~ vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugUpdate +PlugClean! +qall
pip3 install vim-vint

echo "Success \o/"
