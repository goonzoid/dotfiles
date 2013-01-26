source ~/bin/git-completion.bash

/usr/bin/chflags nohidden ~/Library

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH="$HOME/bin:$PATH"

NODE_PATH=/usr/local/lib/node_modules

source '.aliases'
