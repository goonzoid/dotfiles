# Editing
export EDITOR="vim"
bindkey -e
setopt interactivecomments

# Completion
autoload -U compinit && compinit
zstyle ':completion:*' menu select
setopt completealiases

# Colours!
autoload -U colors && colors
export GREP_OPTIONS="--color"
export LSCOLORS="gxfxcxdxbxegedabagacad"

# Prompt
NOWDOTHIS=.nowdothis
function nowdothis() {
  echo $(head -1 $NOWDOTHIS 2> /dev/null) || return
}
function xx() {
  local thing
  thing=$(head -1 $NOWDOTHIS 2> /dev/null)
  if [ "$thing" = "" ]; then return; fi
  newlist=$(tail -n +2 $NOWDOTHIS)
  echo $newlist > $NOWDOTHIS
  echo "\"$thing\" done!"
}
alias ndt="vim $NOWDOTHIS"
autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[green]%}[%b]%a%{$reset_color%}"
precmd() { vcs_info }
setopt prompt_subst
autoload -U promptinit && promptinit
PROMPT='%{$fg[green]%}%m %{$fg[magenta]%}%~ %{$reset_color%}${vcs_info_msg_0_} %{$fg[yellow]%}$(nowdothis) %{$reset_color%}
%{$fg[blue]%}❯ %{$reset_color%}'

# Better history
HISTFILE="$HOME/.zhistory"
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups hist_ignore_space

# Dir stack
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome pushdignoredups pushdminus
alias dirs='dirs -v'

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Aliases
alias ls='ls -aG'
alias ll='ls -AlhG'

alias mkdir='mkdir -p'

alias be='bundle exec'

alias serve='python -m SimpleHTTPServer'

# iTerm tab/window naming
function name() {
  echo -e "\033];$1\007";
}

# Simple One File C++ compilation
function ofc() {
  g++ -Wall -Wextra -pedantic $1 -o `echo $1 | sed 's/\.cpp//'`
}

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export BOSH_USE_BUNDLER=true

PATH="$HOME/bin:$GOBIN:$HOME/.vim/plugged/vipe:$PATH"

eval "$(rbenv init -)"
eval "$(direnv hook $0)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
