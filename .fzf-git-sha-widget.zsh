if [[ $- == *i* ]]; then

__gssel() {
  local cmd='git log --pretty="tformat:%h %s"'
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

fi
