if [ -f "$HOME/bin/st" ] && [[ "${OSTYPE}" =~ "linux" ]]; then
    git config --global core.editor "~/bin/st -w"
elif [ -f "$HOME/bin/st" ]; then
    git config --global core.editor "~/bin/st"
else
    git config --global core.editor "vim"
fi
