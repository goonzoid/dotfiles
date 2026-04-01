#!/usr/bin/env bash

set -e

UPDATE_PLUGINS=false
if [ "${1:-}" = "--update-plugins" ]; then
    UPDATE_PLUGINS=true
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
os="$(uname)"

# install packages
if [ "$os" = "Darwin" ]; then
    "$DOTFILES_DIR/packages/darwin.sh"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
elif [ "$os" = "Linux" ]; then
    "$DOTFILES_DIR/packages/arch.sh"
fi

# install plugins (zsh + tmux), optionally updating existing ones
if [ "$UPDATE_PLUGINS" = true ]; then
    "$DOTFILES_DIR/plugins.sh" --update
else
    "$DOTFILES_DIR/plugins.sh"
fi

# stow dotfiles
STOW_PACKAGES=(
    ghostty
    git
    nvim
    tmux
    zed
    zsh
)
cd "$DOTFILES_DIR"
stow -v --restow "${STOW_PACKAGES[@]}"

# macOS: fix C-w in text fields
# this must be a real file, not a symlink, for apps to pick it up
if [ "$os" = "Darwin" ]; then
    mkdir -p ~/Library/KeyBindings
    printf '{\n\t"^w" = "deleteWordBackward:";\n}' > ~/Library/KeyBindings/DefaultKeyBinding.dict
fi

# WSL: xdg-open shim
if [ "$os" = "Linux" ] && grep -qi microsoft /proc/version 2>/dev/null; then
    pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl
fi

echo "Done!"

# vim: tw=0
