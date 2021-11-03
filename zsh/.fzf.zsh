if [[ $- == *i* ]]; then

# Key bindings
source "/$HOME/.fzf/shell/key-bindings.zsh"

__gssel() {
  local cmd='git log --all --pretty="tformat:%h (%ar)	%s"'
  setopt localoptions pipefail 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${${(z)item}[1]} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-git-sha-widget() {
  LBUFFER="${LBUFFER}$(__gssel)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   fzf-git-sha-widget
bindkey '^G' fzf-git-sha-widget

# Auto-completion
#
# fzf/shell/completion.zsh checks for declerations of _fzf_compgen_{path,dir}, so
# declare before sourcing that
#
# the first argument is the base path to start traversal

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

source "/$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# for some reason $prefix is set, but $lbuf is passed as the first argument
_fzf_complete_git() {
  if [ "${${(z)1}[2]}" = "show" ]; then
    matches=$(__gssel)
    if [ -n "$matches" ]; then
      LBUFFER="$lbuf$matches"
      zle redisplay
      typeset -f zle-line-init >/dev/null && zle zle-line-init
    fi
  else
    _fzf_path_completion "$prefix" "$1"
  fi
}

fi

# Configuration
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='fd -IH'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

if [[ ! "$PATH" == */${HOME}/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/${HOME}/.fzf/bin"
fi
