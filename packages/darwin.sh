#!/usr/bin/env bash

set -e

if [ "$(uname -m)" = "arm64" ]; then
    BREW_PATH="/opt/homebrew/bin/brew"
else
    BREW_PATH="/usr/local/bin/brew"
fi

if [[ ! -x "$BREW_PATH" ]]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($BREW_PATH shellenv)"

brew install \
    bash \
    bat \
    btop \
    cmake \
    cmatrix \
    coreutils \
    direnv \
    fd \
    fzf \
    git \
    git-delta \
    gnu-sed \
    htop \
    jq \
    ncdu \
    pstree \
    ripgrep \
    rustup \
    shellcheck \
    sox \
    stow \
    tmux \
    tree \
    universal-ctags \
    watch \
    watchexec \
    wget \
    yazi \
    yq
