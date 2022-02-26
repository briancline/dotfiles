[[ "${OSTYPE}" =~ "darwin" ]] && alias os_readlink='readlink'
[[ "${OSTYPE}" =~ "linux" ]] && alias os_readlink='readlink -f'

DOTFILES_PATH=$(dirname $(os_readlink ~/.zshrc))


. $DOTFILES_PATH/common.sh

PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=$PATH:$HOME/bin
PATH=$PATH:$DOTFILES_PATH/bin

PROMPT_PREFIXES=()
PROMPT_SUFFIXES=()

precmd () {
    ## Set prompt, window title, and tab title
    local _prefix=""
    local _suffix=""
    local _prefixes="${PROMPT_PREFIXES}"

    # automatically add virtualenv name to prefixes when present
    if [ -n "${VIRTUAL_ENV}" ]; then
        _prefixes="$_prefixes $(basename "${VIRTUAL_ENV}")"
    fi

    [ -n "${_prefixes}" ] && _prefix="%{$fg[green]%}[${_prefixes}]%{$reset_color%} "
    [ -n "${PROMPT_SUFFIXES}" ] && _suffix=" %{$fg[green]%}[${PROMPT_SUFFIXES}]%{$reset_color%}"

    # if previous command returned non-zero error code, turn our prompt character red
    local rc_color="%(?.%{$reset_color%}.$fg_bold[red])"

    export PROMPT="${_prefix}%{$fg[blue]%}${PROMPT_HOST}:%~%{$reset_color%}${_suffix}%{$rc_color%}%#%{$reset_color%} "
    print -Pn "\e]2;%n@${PROMPT_HOST%.*.*}:%~\a"  ## window
    print -Pn "\e]1;%n@${PROMPT_HOST%.*.*}:%~\a"  ## tab
}

prompt_read_host () {
    export PROMPT_HOST_FULL="$(hostname -f)"
    export PROMPT_HOST="${${PROMPT_HOST_FULL/.local/}%.*.*}"
}

prompt_prefix_add () {
    PROMPT_PREFIXES+=("$1")
}
prompt_prefix_remove () {
    PROMPT_PREFIXES=(${(@)PROMPT_PREFIXES:#$1})
}

prompt_suffix_add () {
    PROMPT_SUFFIXES+=("$1")
}
prompt_suffix_remove () {
    PROMPT_SUFFIXES=(${(@)PROMPT_PREFIXES:#$1})
}

path_prepend () {
    path=("$1" $path)
}
path_append () {
    path+=("$1")
}
path_remove () {
    path=(${(@)path:#$1})
}

source_if_exists () {
    [[ -f "$1" ]] && source "$1"
}

randpass () {
    [[ "$2" == "0" ]] && CHAR="[:alnum:]" || CHAR="[:graph:]"
    cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-32}
    echo
}

nowrap () {
    local _cols=${1:-$(tput cols)}
    cut -c -${_cols}
}

imv() {
    local src dst
    for src; do
        [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
        dst=$src
        vared -p 'New file name: ' dst
        [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst
    done
}

va () {
    local _env=${1:-.env}
    if ! [ -d "${PWD}/${_env}" ]; then
        echo >&2 "Error: ${_env} does not exist"
        return 1
    elif ! [ -f "${PWD}/${_env}/bin/activate" ]; then
        echo >&2 "Error: ${_env}/bin/activate does not exist or is not a file"
        return 1
    elif [ -n "${VIRTUAL_ENV}" ]; then
        echo >&2 "Error: Already using ${VIRTUAL_ENV}"
        return 1
    fi

    source "${PWD}/${_env}/bin/activate"
}

vn () {
    local _env=${1:-.env}
    if [ -d "${PWD}/${_env}" ]; then 
        echo >&2 "Error: Directory ${_env} already exists"
        return 1
    fi

    if [ "2" = "$(python -c "import sys; print(sys.version_info.major)")" ]; then
        virtualenv ${_env}
    else
        python3 -m venv ${_env}
    fi
}

de () {
    if [ -z "${VIRTUAL_ENV}" ]; then
        echo >&2 "Error: No virtual environment is active"
        return 1
    fi

    deactivate
}

find_sublime () {
    OSX_SUBLIME_BIN="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
    LINUX_SUBLIME_BIN="/opt/sublime_text/sublime_text"

    if which subl >/dev/null 2>&1 ; then
        # No need to alias if it's in our path
        return
    elif [ -x "${OSX_SUBLIME_BIN}" ]; then
        SUBLIME_BIN="${OSX_SUBLIME_BIN}"
    elif [ -x "${LINUX_SUBLIME_BIN}" ]; then
        SUBLIME_BIN="${LINUX_SUBLIME_BIN}"
    fi
}

_detect_platform
prompt_read_host

if [ -d ~/.zsh/completion ]; then
    fpath=(~/.zsh/completion $fpath)
fi

autoload -U compinit && compinit
autoload -U colors && colors

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_TO_HOME

setopt EMACS
setopt GLOB_COMPLETE
setopt NUMERIC_GLOB_SORT
setopt RC_EXPAND_PARAM

export TERM=xterm-256color
export EDITOR="vim"
export LS_OPTIONS='--color=auto'


if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
elif [ "${PLATFORM}" = "macos" ] && [ -x /usr/local/bin/gdircolors ]; then
    eval "$(gdircolors -b)"
else
    export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;45:tw=:ow=:"  # linux
    export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"  # osx
fi

if [[ "${OSTYPE}" =~ "linux" ]]; then
    alias ls="ls ${LS_OPTIONS}"
elif [[ "${OSTYPE}" =~ "darwin" ]]; then
    export CLICOLOR="yes"

    if [ -x /usr/local/bin/gls ]; then
        alias ls="gls ${LS_OPTIONS}"
    else
        alias ls='ls -G'
    fi
fi

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias llt='ls -ltr'

alias tmux='tmux -2'
alias tx='tmux -2'
alias txl='tmux list-sessions'
alias txa='tmux attach-session -t'
alias txn='tmux new-session -s'

alias ez='vim ~/.zshrc'
alias sl='slcli'

if [ -f ~/.bcrc ]; then
    alias bc='bc -l ~/.bcrc'
fi

if which jq >/dev/null 2>&1 ; then
    alias json='jq .'
elif which rich >/dev/null 2>&1 ; then
    # TODO: this needs to run after pyenv init
    alias json='rich --json -'
else
    alias json='python -m json.tool'
fi


if [[ "${OSTYPE}" =~ "linux" ]]; then
    CKEYS_FILE="/usr/share/X11/locale/en_US.UTF-8/Compose"
    if [ -f "${CKEYS_FILE}" ]; then
        alias ckeys="${EDITOR} ${CKEYS_FILE}"
    fi
fi


bindkey '^[[1~' beginning-of-line      # Home
bindkey '^[[H' beginning-of-line       # Home
bindkey '^[OH' beginning-of-line       # Home
bindkey '^[[4~' end-of-line            # End
bindkey '^[[F'  end-of-line            # End
bindkey '^[OF' end-of-line             # End

bindkey '^[[5~' beginning-of-history   # PgUp
bindkey '^[[6~' end-of-history         # PgDown
bindkey '^[[A' up-line-or-search       # Up
bindkey '^[[B' down-line-or-search     # Down

bindkey '^[w' kill-region              # Esc-w (delete entire line)
bindkey '^[[3~' delete-char            # Del

HISTFILE=~/.history
SAVEHIST=500000
HISTSIZE=100000

setopt INTERACTIVECOMMENTS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS


if grep -qi 'microsoft' /proc/version 2>/dev/null; then
    source_if_exists ~/.zsh/wsl.sh
fi

source_if_exists ~/.env-work/.zshrc
source_if_exists ~/.zsh/ssh-util.sh
source_if_exists ~/.zsh/git-prompt.sh
source_if_exists ~/.zsh/git-editor.sh
source_if_exists ~/.zsh/git-ignore.sh
source_if_exists ~/.zsh/chef.sh
source_if_exists ~/.zsh/packer.sh
source_if_exists ~/.zsh/swag.sh
source_if_exists ~/.zsh/sl-utils.sh
source_if_exists ~/.slrc


# Detect whether we have Sublime Text, and if so, alias its binary
find_sublime
if [ -n "${SUBLIME_BIN}" ]; then
    alias subl="'${SUBLIME_BIN}'"
fi


# Load pyenv if we have it
if [ -x $HOME/.pyenv/bin/pyenv ]; then
    export PYENV_ROOT=$HOME/.pyenv
    path_prepend "${PYENV_ROOT}/bin"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Load rbenv if we have it
if [ -d "${HOME}/.rbenv" ]; then
    export ENV_USE_RBENV=1
    path_prepend "${HOME}/.rbenv/bin"
    eval "$(rbenv init -)"
fi

# Load rvm if we have it, aren't using rbenv, and not explicitly disabling it
# if [ -s "$HOME/.rvm/scripts/rvm" ] && [ ! "$ENV_USE_RBENV" = "1" ] && [ ! "$ENV_NO_RVM" = "1" ]; then
#     path_append $HOME/.rvm/bin
#     source "$HOME/.rvm/scripts/rvm"
# fi


# Prevents previous test return code in this script from leaking into initial
# prompt's coloring of prompt char (which is based on return code)
true
