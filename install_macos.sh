#!/usr/bin/env bash

set -e -u

if ! [ -x "$(command -v brew)" ]; then
    echo "brew not found, install homebrew and try again"
    exit 1
fi
brew tap homebrew/bundle && brew bundle

rehash # so that command -v returns homebrew zsh path
chsh -s "$(command -v zsh)"

./install_or_update.sh
