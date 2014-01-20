OSX_SUBLIME_BIN="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
LINUX_SUBLIME_BIN="$(which subl 2>/dev/null)"
LINUX_SUBLIME_HOME_BIN="$HOME/apps/sublime-3/sublime_text"
LINUX_SUBLIME_OPT_BIN="/opt/sublime_text/sublime_text"
VIM_LOCATION="$(which vim 2>/dev/null)"
VI_LOCATION="$(which vi 2>/dev/null)"
NANO_LOCATION="$(which nano 2>/dev/null)"

HOME_EDITOR="${HOME}/bin/st"

if [ ! -f "$HOME_EDITOR" ]; then
    mkdir -p ~/bin

    if [ -f "$OSX_SUBLIME_BIN" ]; then
        ln -s $OSX_SUBLIME_BIN $HOME_EDITOR
    elif [ -f "$LINUX_SUBLIME_OPT_BIN" ]; then
        ln -s $LINUX_SUBLIME_OPT_BIN $HOME_EDITOR
    elif [ -f "$LINUX_SUBLIME_BIN" ]; then
        ln -s $LINUX_SUBLIME_BIN $HOME_EDITOR
    elif [ -f "$LINUX_SUBLIME_HOME_BIN" ]; then
        ln -s $LINUX_SUBLIME_HOME_BIN $HOME_EDITOR
    elif [ "$VIM_LOCATION" ]; then
        ln -s $VIM_LOCATION $HOME_EDITOR
    elif [ "$VI_LOCATION" ]; then
        ln -s $VI_LOCATION $HOME_EDITOR
    elif [ "$NANO_LOCATION" ]; then
        ln -s $NANO_LOCATION $HOME_EDITOR
    else:
        echo 'ERROR: No editors found. Good luck!' >/dev/stderr
    fi
fi
