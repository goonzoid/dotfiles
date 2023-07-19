#!/usr/bin/env bash

set -e -u

if ! [ -x "$(command -v brew)" ]; then
    echo "brew not found, install homebrew and try again"
    exit 1
fi
brew tap homebrew/bundle && brew bundle

hash -r # so that command -v returns homebrew zsh path
zsh_path="$(command -v zsh)"
if ! grep -q "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells
fi
chsh -s "$zsh_path"

mkdir -p ~/Library/KeyBindings
printf '{\n\t"^w" = "deleteWordBackward:";\n}' > ~/Library/KeyBindings/DefaultKeyBinding.dict

./install_or_update.sh
