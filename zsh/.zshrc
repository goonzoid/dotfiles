# Editing
export EDITOR="vim"
bindkey -e
setopt interactivecomments

# Help
autoload run-help

# Completion
autoload -U compinit && compinit
zstyle ':completion:*' menu select
setopt completealiases

# Colours!
autoload -U colors && colors
export LSCOLORS="gxfxcxdxbxegedabagacad"

# Now Do This
NOWDOTHIS=.nowdothis
nowdothis() {
  echo $(head -1 $NOWDOTHIS 2> /dev/null) || return
}
alias now=nowdothis
xx() {
  local thing
  thing=$(head -1 $NOWDOTHIS 2> /dev/null)
  if [ "$thing" = "" ]; then return; fi
  newlist=$(tail -n +2 $NOWDOTHIS)
  echo $newlist > $NOWDOTHIS
  echo "\"$thing\" done!"
}
next() {
  tail -n +2 $NOWDOTHIS
}
alias ndt="vim $NOWDOTHIS"

# Prompt
autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[green]%}%b:%u%c%a%{$reset_color%}"
precmd() { vcs_info }
setopt prompt_subst
autoload -U promptinit && promptinit
PROMPT='%{$fg[magenta]%}%m %{$fg[blue]%}%~ %{$reset_color%}${vcs_info_msg_0_} %{$reset_color%}
%{$fg[blue]%}❯ %{$reset_color%}'
RPROMPT='%(?..%{$fg[red]%}%?%{$reset_color%})'

# Better history
HISTFILE="$HOME/.zhistory"
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt append_history share_history hist_ignore_all_dups hist_ignore_space

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

alias grep='grep --color=auto'

alias agg='ag --nobreak --nofilename'

alias tma='tmux attach || tmux'

alias serve='python -m SimpleHTTPServer'

# iTerm tab/window naming
iterm_name() {
  echo -e "\033];$1\007";
}

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

eval "$(direnv hook $0)"

PATH="$HOME/bin:$HOME/.local/bin:$GOBIN:$HOME/.cargo/bin:$PATH"

source "$HOME/.fzf.zsh"

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# No duplicates in $PATH
typeset -U path

# Plugins - must be loaded after all calls to zle and compinit
# source $HOME/.zplugins.sh

# zsh_update_plugins() {
#   antibody bundle < ~/.zplugins.txt > ~/.zplugins.sh
#   sed -i '' "s,$HOME,\$HOME,g" ~/.zplugins.sh
# }

# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# ZSH_HIGHLIGHT_STYLES[path]='fg=white'
