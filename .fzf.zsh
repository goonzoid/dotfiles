# Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
source "$HOME/.fzf-git-sha-widget.zsh"

# Auto-completion
if [[ $- == *i* ]]; then

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

source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

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
