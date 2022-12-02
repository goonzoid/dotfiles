#!/usr/bin/env bash

set -e -u

sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt update
sudo apt install -y git stow zsh fd-find tmux tree vim python3-pip
chsh -s "$(command -v zsh)"
mkdir -p ~/.local/bin
ln -f -s "$(command -v fdfind)" ~/.local/bin/fd

if ! command -v ctags &> /dev/null
then
    git clone git@github.com:universal-ctags/ctags "$TMPDIR/ctags"
    pushd "$TMPDIR/ctags"
      ./autogen.sh
      ./configure
      make
      make install
    popd
fi

if grep -qi microsoft /proc/version; then
    pip3 install --user git+https://github.com/cpbotha/xdg-open-wsl
fi

./install_or_update.sh
