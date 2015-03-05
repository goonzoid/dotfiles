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
function rbenv_prompt_info() {
  local ruby_version
  ruby_version=$(rbenv version 2> /dev/null) || return
  echo "[$ruby_version" | sed -e "s/ (set.*$/]/"
}
alias rvm-prompt=rbenv_prompt_info
alias rvm_prompt_info=rbenv_prompt_info
autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[green]%}[%b]%a "
precmd() { vcs_info }
setopt prompt_subst
autoload -U promptinit && promptinit
PROMPT='%{$fg[green]%}%m %{$fg[magenta]%}%~ %{$fg[red]%}$(rvm-prompt i v g s)%{$reset_color%} ${vcs_info_msg_0_}
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

PATH="$HOME/bin:$GOPATH/bin:$HOME/.vim/bundle/vipe:$PATH"

eval "$(rbenv init -)"
eval "$(direnv hook $0)"
