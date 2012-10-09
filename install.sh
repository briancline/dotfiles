#!/bin/bash

ln -fs ~/env/.zshrc ~/.zshrc
ln -fs ~/env/.tmux.conf ~/.tmux.conf
ln -fs ~/env/.vimrc ~/.vimrc
ln -fs ~/env/vim ~/.vim
ln -fs ~/env/.gitconfig-home ~/.gitconfig

chsh -s $(which zsh)

