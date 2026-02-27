#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_ZSH_PLUGINS=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--zsh-plugins]

Options:
  --zsh-plugins   Clone/update zsh plugins used by zshrc.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --zsh-plugins)
      INSTALL_ZSH_PLUGINS=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[!] unknown argument: $arg"
      usage
      exit 1
      ;;
  esac
done

DOTFILES=(
  "zshrc:.zshrc"
  "vimrc:.vimrc"
  "tmux.conf:.tmux.conf"
  "gitconfig:.gitconfig"
)

for entry in "${DOTFILES[@]}"; do
  src_name="${entry%%:*}"
  dest_name="${entry#*:}"
  src_path="$SCRIPT_DIR/$src_name"
  dest_path="$HOME/$dest_name"

  if [ ! -e "$src_path" ]; then
    echo "[!] missing source file: $src_path"
    exit 1
  fi

  if ln -sf "$src_path" "$dest_path"; then
    echo "[*] $src_name symlinked to $dest_path"
  else
    echo "[!] error symlinking $src_name to $dest_path"
    exit 1
  fi
done

install_or_update_plugin() {
  local repo="$1"
  local dir="$2"
  local target_ref

  if ! command -v git >/dev/null 2>&1; then
    echo "[!] git is required to install zsh plugins"
    exit 1
  fi

  if [ -d "$dir/.git" ]; then
    if git -C "$dir" fetch --depth 1 origin; then
      target_ref="$(git -C "$dir" symbolic-ref -q --short refs/remotes/origin/HEAD || true)"
      if [ -n "$target_ref" ]; then
        target_ref="${target_ref#origin/}"
        target_ref="origin/$target_ref"
      else
        target_ref="origin/$(git -C "$dir" rev-parse --abbrev-ref HEAD)"
      fi
    else
      echo "[!] failed to fetch $(basename "$dir")"
      exit 1
    fi

    if git -C "$dir" reset --hard "$target_ref" && git -C "$dir" clean -fdx; then
      echo "[*] updated $(basename "$dir")"
    else
      echo "[!] failed to update $(basename "$dir")"
      exit 1
    fi
  elif [ -d "$dir" ]; then
    echo "[!] directory exists but is not a git repo: $dir"
    exit 1
  else
    if git clone --depth 1 "$repo" "$dir"; then
      echo "[*] cloned $(basename "$dir")"
    else
      echo "[!] failed to clone $repo"
      exit 1
    fi
  fi
}

if [ "$INSTALL_ZSH_PLUGINS" -eq 1 ]; then
  mkdir -p "$SCRIPT_DIR/zsh"
  install_or_update_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "$SCRIPT_DIR/zsh/zsh-autosuggestions"
  install_or_update_plugin "https://github.com/agkozak/zsh-z.git" "$SCRIPT_DIR/zsh/zsh-z"
fi
