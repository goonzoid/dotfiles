BREW_PATH="/opt/homebrew/bin/brew"
[[ -e $BREW_PATH ]] && eval "$($BREW_PATH shellenv)"

NIX_DAEMON_PATH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
[[ -e $NIX_DAEMON_PATH ]] && source $NIX_DAEMON_PATH

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.rbenv/shims:$PATH"

# vim: tabstop=2
