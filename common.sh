os_readlink_safe () {
    local real_path="$(os_readlink "$1" 2>/dev/null)"

    ## the real location
    [ -n "$real_path" ] && echo $real_path && return

    ## the input, if it's an existing file or dir
    ( [ -f "$1" ] || [ -d "$1" ] ) && echo $1 && return

    ## must not exist (or is a type we don't care about)
    return 1
}

_detect_platform () {
    if [[ -f /etc/lsb-release ]]; then
        PLATFORM=$(source /etc/lsb-release; echo ${DISTRIB_ID} | awk '{print tolower($0)}')
        PKG_INSTALL_CMD="$SUDO apt-get install -y"
    elif [[ -f /etc/debian_version ]]; then
        PLATFORM=debian
        PKG_INSTALL_CMD="$SUDO apt-get install -y"
    elif [[ -f /etc/centos-release ]]; then
        PLATFORM=centos
        PKG_INSTALL_CMD="$SUDO yum install -y"
        PIP_CMD=pip-python
    elif [[ -f /etc/redhat-release ]]; then
        PLATFORM=rhel
        PKG_INSTALL_CMD="$SUDO yum install -y"
        PIP_CMD=pip-python
    elif [[ "${OSTYPE}" =~ "^darwin" ]]; then
        PLATFORM=macos
        PKG_INSTALL_CMD="brew install"
    fi

    export PLATFORM
    export PKG_INSTALL_CMD
    export PIP_CMD
}

