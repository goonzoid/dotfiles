#!/usr/bin/env bash

set -e

echo "WARNING: This script has not been tested — package names may need adjusting. Verify the results!"

sudo pacman -Syu --needed --noconfirm \
    bash \
    bat \
    btop \
    cmake \
    cmatrix \
    coreutils \
    curl \
    direnv \
    fd \
    fzf \
    github-cli \
    git \
    git-delta \
    htop \
    jq \
    ncdu \
    ripgrep \
    rustup \
    shellcheck \
    sox \
    stow \
    tmux \
    tree \
    ctags \
    watchexec \
    wget \
    yazi \
    yq
