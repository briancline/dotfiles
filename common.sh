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
    elif [[ -f /etc/debian_version ]]; then
        PLATFORM=debian
    elif [[ -f /etc/centos-release ]]; then
        PLATFORM=centos
    elif [[ -f /etc/redhat-release ]]; then
        PLATFORM=rhel
    elif [[ "${OSTYPE}" =~ "^darwin" ]]; then
        PLATFORM=macos
    fi

    export PLATFORM
}

