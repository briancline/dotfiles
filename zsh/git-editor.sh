if [ -f "$EDITOR" ]; then
    export EDITOR_NAME="$(basename "$(os_readlink_safe $EDITOR)")"
    export GIT_EDITOR="$EDITOR_NAME"

    if [[ "$EDITOR_NAME" =~ "^subl" ]]; then
        ## If we're on a machine using Sublime Text as our editor, instruct
        ## Sublime to wait (with -w) until the file git sends to it is closed
        ## before returning anything back to git. Otherwise, git sees an
        ## immediate exit and cancels the commit/rebase/merge/whatever due to
        ## no changes in the file.
        export GIT_EDITOR="$GIT_EDITOR -w"
    fi
fi


# Remove a symlink this file used to create to point at the preferred editor.
# Can't remember why I needed it nearly a decade ago, but I don't use it now.
if [ -L "${HOME}/bin/e" ]; then
    rm -f "${HOME}/bin/e"
fi

# Old symlinks to sublime_text also aren't necessary anymore
if [ -L "${HOME}/bin/subl" ]; then
    rm -f "${HOME}/bin/subl"
fi
