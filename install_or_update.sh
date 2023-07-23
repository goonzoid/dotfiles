#!/usr/bin/env bash

set -e

clone_if_not_present () {
    if [[ ! -d "$2" ]]; then
        git clone "$1" "$2"
    else
        echo "$2 already exists - skipping"
    fi
}

clone_if_not_present git@github.com:tmux-plugins/tpm ~/.tmux/plugins/tpm

clone_if_not_present git@github.com:junegunn/fzf ~/.fzf
~/.fzf/install --bin

clone_if_not_present git@github.com:zsh-users/zsh-syntax-highlighting ~/.config/zplugins/zsh-syntax-highlighting

clone_if_not_present git@github.com:zsh-users/zsh-autosuggestions ~/.config/zplugins/zsh-autosuggestions

clone_if_not_present git@github.com:sindresorhus/pure ~/.config/zplugins/pure

stow -t ~ zsh

mkdir -p ~/bin
stow -t ~/bin bin

stow -t ~ git

stow -t ~ tmux

mkdir -p ~/.config/nvim
stow -t ~/.config/nvim nvim

if ! command -v rustup &> /dev/null
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    # shellcheck source=/dev/null
    # https://www.shellcheck.net/wiki/SC1090
    source ~/.cargo/env
fi
rustup component add rust-analyzer

echo "Success \o/ - don't forget to install tmux plugins"

# vim: tw=0
