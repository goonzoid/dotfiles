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
PROMPT='%{$fg[green]%}%m %{$fg[magenta]%}%~ %{$fg[red]%}[$(rvm-prompt i v g s)]%{$reset_color%} ${vcs_info_msg_0_}
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

source "$HOME/.aliases"

PATH="/usr/local/bin:$HOME/bin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"
PATH="/Applications/Racket v5.3.4/bin:$PATH"
PATH="$PATH:$HOME/.rvm/bin"

