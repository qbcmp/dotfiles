# Common variables -------------------------------------------------------------

DOTFILES_DIR="$HOME/Projects/dotfiles"

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

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v docker >/dev/null 2>&1; then
  source <(docker completion zsh)
fi

if command -v kind >/dev/null 2>&1; then
  source <(kind completion zsh)
  compdef _kind kind 2>/dev/null || true
fi

# Sources ----------------------------------------------------------------------

source $DOTFILES_DIR/aliases


