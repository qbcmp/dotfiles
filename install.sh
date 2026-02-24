#!/bin/bash

set -u

DOTFILES=(
  "zshrc:.zshrc"
  "vimrc:.vimrc"
  "tmux.conf:.tmux.conf"
)

for entry in "${DOTFILES[@]}"; do
  src_name="${entry%%:*}"
  dest_name="${entry#*:}"
  src_path="$PWD/$src_name"
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
