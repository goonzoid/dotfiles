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

[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
source "$HOME/.fzf-git-sha-widget.zsh"

# Configuration
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='fd -IH'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
