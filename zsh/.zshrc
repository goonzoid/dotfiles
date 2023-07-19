# Editing
export EDITOR="nvim"
bindkey -e
setopt interactivecomments

# Help
autoload run-help

# Completion
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
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
fpath+=$HOME/.config/zplugins/pure
autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:git:stash show yes
if [[ -z $TMUX ]]; then
    prompt_pure_set_title() {}
fi

# Better history
HISTSIZE=10000
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
alias ls='ls -aGB'
alias ll='ls -AlhG'
alias grep='grep --color=auto'
alias tma='tmux attach || tmux'
alias serve='python -m SimpleHTTPServer'
alias vim='nvim'
alias k='kubectl'

# iTerm tab/window naming
iterm_name() {
  echo -e "\033];$1\007";
}

if (( $+commands[direnv] )); then
  eval "$(direnv hook $0)"
fi

source "$HOME/.fzf.zsh"
source "$HOME/.config/zplugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.config/zplugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[path]='fg=green'

# No duplicates in $PATH
typeset -U path
