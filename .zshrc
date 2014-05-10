# Editing
export EDITOR="/usr/local/bin/mvim -v"
bindkey -e

# Completion
autoload -U compinit && compinit
zstyle ':completion:*' menu select
setopt completealiases

# Colours!
autoload -U colors && colors
export GREP_OPTIONS="--color"
export LSCOLORS="gxfxcxdxbxegedabagacad"

# Prompt
autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[green]%}[%b]%a "
precmd() { vcs_info }
setopt prompt_subst
autoload -U promptinit && promptinit
PROMPT='%{$fg[green]%}%m %{$fg[magenta]%}%~ %{$reset_color%}${vcs_info_msg_0_}
%{$fg[blue]%}❯ %{$reset_color%}'

# Better history
HISTFILE="$HOME/.zhistory"
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups hist_ignore_space

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Aliases
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -AhG'
alias lal='ls -AlhG'

alias mkdir='mkdir -p'

alias be='bundle exec'

alias python='python3'
alias serve='python -m SimpleHTTPServer'

alias vim='mvim -v'
alias vi='vim'
alias emacs='/usr/local/Cellar/emacs/24.2/bin/emacs'

# iTerm tab/window naming
function name() {
  echo -e "\033];$1\007";
}

export GOPATH="$HOME/workspace/go"

# PATH
PATH="/usr/local/bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"
PATH="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin:$PATH"
PATH="/Applications/Racket v5.3.4/bin:$PATH"
PATH="$HOME/bin:$PATH"

# rbenv
eval "$(rbenv init -)"

