if [ -f "$HOME/bin/st" ]; then
    git config --global core.editor "~/bin/st -w"
else
    git config --global core.editor "vim"
fi

