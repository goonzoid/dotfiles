#!/usr/bin/env bash

set -e

UPDATE=false
if [ "${1:-}" = "--update" ]; then
    UPDATE=true
fi

PLUGINS_DIR="$HOME/.local/share/zplugins"
mkdir -p "$PLUGINS_DIR"

ensure_plugin() {
    local repo="$1" dir="$2"
    if [ -d "$dir" ]; then
        if [ "$UPDATE" = true ]; then
            echo "Updating $(basename "$dir")..."
            git -C "$dir" pull --ff-only || echo "Warning: Failed to update $(basename "$dir")" >&2
        fi
    else
        echo "Cloning $(basename "$dir")..."
        git clone --depth 1 "$repo" "$dir"
    fi
}

# zsh plugins
ensure_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "$PLUGINS_DIR/zsh-syntax-highlighting"
ensure_plugin "https://github.com/zsh-users/zsh-autosuggestions"     "$PLUGINS_DIR/zsh-autosuggestions"
ensure_plugin "https://github.com/hlissner/zsh-autopair"             "$PLUGINS_DIR/zsh-autopair"
ensure_plugin "https://github.com/sindresorhus/pure"                 "$PLUGINS_DIR/pure"

# tmux plugin manager
ensure_plugin "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
