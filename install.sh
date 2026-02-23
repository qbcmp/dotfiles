#!/bin/bash

if ln -sf $PWD/zshrc ~/.zshrc; then
    echo "[*] zshrc symlinked to ~/.zshrc"
else
    echo "[!] error symlinking zshrc to ~/.zshrc"
fi
