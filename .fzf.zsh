# Auto-completion
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
source "$HOME/.fzf-git-sha-widget.zsh"

# Configuration
export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='fd -IH'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
