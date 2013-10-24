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

