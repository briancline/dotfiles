HOME_EDITOR_SUBL="${HOME}/bin/subl"
HOME_EDITOR_ST="${HOME}/bin/st"
HOME_EDITOR="${HOME}/bin/e"

if [ ! -f "$HOME_EDITOR" ] || [ ! -f "$HOME_EDITOR_SUBL" ]; then
    mkdir -p ~/bin

    OSX_SUBLIME_BIN="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
    LINUX_SUBLIME_BIN="$(which subl 2>/dev/null)"
    LINUX_SUBLIME_HOME_BIN="$HOME/apps/sublime-3/sublime_text"
    LINUX_SUBLIME_OPT_BIN="/opt/sublime_text/sublime_text"
    VIM_LOCATION="$(which vim 2>/dev/null)"
    VI_LOCATION="$(which vi 2>/dev/null)"
    NANO_LOCATION="$(which nano 2>/dev/null)"

    if [ -f "$OSX_SUBLIME_BIN" ]; then
        ln -fs $OSX_SUBLIME_BIN $HOME_EDITOR
        ln -fs $OSX_SUBLIME_BIN $HOME_EDITOR_SUBL
    elif [ -f "$LINUX_SUBLIME_OPT_BIN" ]; then
        ln -fs $LINUX_SUBLIME_OPT_BIN $HOME_EDITOR
        ln -fs $LINUX_SUBLIME_OPT_BIN $HOME_EDITOR_SUBL
    elif [ -f "$LINUX_SUBLIME_BIN" ]; then
        ln -fs $LINUX_SUBLIME_BIN $HOME_EDITOR
        ln -fs $LINUX_SUBLIME_BIN $HOME_EDITOR_SUBL
    elif [ -f "$LINUX_SUBLIME_HOME_BIN" ]; then
        ln -fs $LINUX_SUBLIME_HOME_BIN $HOME_EDITOR
        ln -fs $LINUX_SUBLIME_HOME_BIN $HOME_EDITOR_SUBL
    elif [ "$VIM_LOCATION" ]; then
        ln -fs $VIM_LOCATION $HOME_EDITOR
    elif [ "$VI_LOCATION" ]; then
        ln -fs $VI_LOCATION $HOME_EDITOR
    elif [ "$NANO_LOCATION" ]; then
        ln -fs $NANO_LOCATION $HOME_EDITOR
    else:
        echo 'ERROR: No editors found. Good luck!' >/dev/stderr
    fi

    if [ ! -f "$HOME_EDITOR_ST" ] && [ -f "$HOME_EDITOR_SUBL" ]; then
        ln -fs "$(readlink $HOME_EDITOR_SUBL)" $HOME_EDITOR_ST
    fi
fi

[[ -f "$HOME_EDITOR" ]] && export EDITOR=$HOME_EDITOR
