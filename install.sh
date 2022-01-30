#!/bin/bash
set -o errexit

PLATFORM=unknown
export CORES=$(grep -c ^processor /proc/cpuinfo)
export MAKEJOBS=$(expr $CORES - 1)

os_readlink="readlink"
[[ "${OSTYPE}" =~ "darwin" ]] && alias os_readlink='readlink'
[[ "${OSTYPE}" =~ "linux" ]] && alias os_readlink='readlink -f'

DOTFILES_PATH=$(dirname $($os_readlink $0 || echo $0))
BACKUP_PATH="${HOME}/old-dotfiles"
CHANGEZSH=false

. ${DOTFILES_PATH}/common.sh


_install_dotfiles () {
    pushd ~
    for ii in .zshrc .zsh .tmux.conf .vimrc .vim .irssi .gitconfig .gitignore-global .bcrc; do
        if [ -L "${ii}" ]; then
            rm -f "${ii}"
        elif [ -f "${ii}" ]; then
            echo "Backing up ${ii} to ${BACKUP_PATH}/${ii}..."
            mkdir -p "${BACKUP_PATH}"
            cp --archive "${ii}" "${BACKUP_PATH}/${ii}"
        elif [ -d "${ii}" ]; then
            mkdir -p "${BACKUP_PATH}"
            echo "Backing up ${ii} to ${BACKUP_PATH}/${ii}.tgz..."
            tar -czf "${BACKUP_PATH}/${ii}.tgz" "${ii}/"
            rm -rf "${ii}"
        fi
    done
    popd

    pushd ${DOTFILES_PATH}
    git submodule update --init --recursive
    popd

    ln -fs ${DOTFILES_PATH}/.zshrc ~/.zshrc
    ln -fs ${DOTFILES_PATH}/zsh ~/.zsh
    ln -fs ${DOTFILES_PATH}/.tmux.conf ~/.tmux.conf
    ln -fs ${DOTFILES_PATH}/.vimrc ~/.vimrc
    ln -fs ${DOTFILES_PATH}/vim ~/.vim
    ln -fs ${DOTFILES_PATH}/.irssi ~/.irssi
    ln -fs ${DOTFILES_PATH}/.gitconfig-home ~/.gitconfig
    ln -fs ${DOTFILES_PATH}/.gitignore-global ~/.gitignore-global
    ln -fs ${DOTFILES_PATH}/.bcrc ~/.bcrc
}

_change_shell_zsh () {
    $CHANGEZSH || return
    if [[ -n "$(which zsh)" ]]; then
        RESULT=$(sudo chsh -s $(which zsh) $USER)
        echo $RESULT
    else
        echo "zsh is not installed on your system."
    fi
}


while getopts ":hspz" option
do
    case $option in
        h) echo "Usage: $0 [-h] [-s] [-p] [-z]"
           echo "  -h   Displays help"
           echo "  -z   Changes shell to zsh"
           exit 0;;

        z) CHANGEZSH=true;;
        *) echo "Unknown option $option"; exit 1;;
    esac
done


_detect_platform
_install_dotfiles
$CHANGEZSH && _change_shell_zsh
