#!/usr/bin/env bash

set -e

# TODO:
# - install nix and home manager
# - enable flakes
# - pin git revisions and remove --impure
home-manager switch --flake .#wminor --impure

os="$(uname)"

# This is here rather than in home.nix because some apps (e.g. Apple Notes) do
# not appear to load these key bindings if the file is symlinked.
if [ "$os" == "Darwin" ]; then
    mkdir -p ~/Library/KeyBindings
    printf '{\n\t"^w" = "deleteWordBackward:";\n}' > ~/Library/KeyBindings/DefaultKeyBinding.dict
fi

# TODO: move this in to home.nix
if [ "$os" == "Linux" ]; then
    if grep -qi microsoft /proc/version; then
        pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl
    fi
fi

# vim: tw=0
