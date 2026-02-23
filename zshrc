# History ----------------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Completion -------------------------------------------------------------------

autoload -Uz compinit && compinit
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':completion:*' menu select
