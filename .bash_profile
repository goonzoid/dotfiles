source ~/bin/git-completion.bash

/usr/bin/chflags nohidden ~/Library

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
PATH="$HOME/bin:$PATH"

NODE_PATH=/usr/local/lib/node_modules

# Aliases
alias vim='mvim -v'
alias vi='mvim -v'
