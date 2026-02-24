#!/bin/bash

if ln -sf $PWD/zshrc ~/.zshrc; then
    echo "[*] zshrc symlinked to ~/.zshrc"
else
    echo "[!] error symlinking zshrc to ~/.zshrc"
fi

if ln -sf $PWD/vimrc ~/.vimrc; then
    echo "[*] vimrc symlinked to ~/.vimrc"
else
    echo "[!] error symlinking vimrc to ~/.vimrc"
fi

if ln -sf $PWD/tmux.conf ~/.tmux.conf; then
    echo "[*] tmux.conf symlinked to ~/.tmux"
else
    echo "[!] error symlinking tmux.conf to ~/.tmux.conf"
fi

