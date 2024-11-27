#!/bin/bash

DF_PATH="$(dirname $(realpath $0))"

if [ -d "${HOME}/.pyenv" ]; then
    echo >&2 "Error: ${HOME}/.pyenv already exists!"
    exit 1
fi

pushd -q ~
git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"

PATH="${HOME}/.pyenv/bin:${PATH}"

eval "$(pyenv init --path)"
hash -r

DIST_ID="$(lsb_release -i -s)"

if echo "${DIST_ID}" | grep -q -E '^(Debian|Ubuntu|LinuxMint)$' ; then
    echo >&1 "Installing required build/devel packages for debian family"
    sudo apt install \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev libsqlite3-dev \
        curl \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev libxmlsec1-dev \
        libffi-dev \
        liblzma-dev
elif [[ "${DIST_ID}" =~ "Fedora" ]]; then
    echo >&1 "Installing required build/devel packages for fedora family"
    sudo dnf install \
        make \
        gcc \
        patch \
        zlib-devel \
        bzip2 bzip2-devel \
        readline-devel \
        sqlite sqlite-devel \
        openssl-devel \
        tk-devel \
        libffi-devel \
        xz-devel \
        libuuid-devel \
        gdbm-libs \
        libnsl2
fi

cat "${DF_PATH}/.python-versions" | while read pyver; do
    echo "$(date -Is) Building Python v${pyver}..."
    time ( pyenv install ${pyver} )
    echo "$(date -Is) Finished building Python v${pyver}."
done

# For desktop envs, send a quick toaster notification when we've finally
# finished installing all pyenv-managed Python versions.
if hash notify-send 2>/dev/null ; then
    _verlist="$(pyenv versions | grep -Ev 'system' | sed -re 's/^(\s+|\*\s+)|\s\(.*//g' | sort -t. -k1,1rn -k 2,2rn -k 3,3rn | sed -re 's/^/  * /')"
    notify-send -a dotfiles -u low "Pyenv installation complete:" "${_verlist}"
fi
