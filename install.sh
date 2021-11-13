#!/usr/bin/env bash

set -e -u

clone_if_not_present () {
    if [[ ! -d "$2" ]]; then
        git clone "$1" "$2"
    else
        echo "$2 already exists - skipping"
    fi
}

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

clone_if_not_present git@github.com:tmux-plugins/tpm ~/.tmux/plugins/tpm

clone_if_not_present git@github.com:chriskempson/base16-shell ~/.config/base16-shell

clone_if_not_present git@github.com:junegunn/fzf ~/.fzf
~/.fzf/install --bin

stow -t ~ zsh
chsh -s "$(command -v zsh)"

stow -t ~ git

stow -t ~ tmux

stow -t ~ vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugUpdate +PlugClean! +qall
pip3 install vim-vint

echo "Success \o/ - don't forget to install tmux plugins"

# vim: tw=0
