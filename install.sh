#!/bin/bash

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
	elif [[ -f /etc/redhat-release ]]; then
		PLATFORM=rhel
		PKG_INSTALL_CMD="$SUDO yum install -y"
	fi
}

_install_system () {
	sudo $ENVPATH/.system-$PLATFORM
}

_install_syspackages () {
	cat .packages-$PLATFORM |
	while read ii; do
		if [[ ! "$ii" ]]; then
			continue
		fi

		if [[ "@" = "${ii:0:1}" ]]; then
			${ii:1}
		else
			$PKG_INSTALL_CMD $ii
		fi
	done
}

_install_python () {
	$SUDO pip install pythonbrew

	pythonbrew off 2>/dev/null
	#rm -rf ~/.pythonbrew
	#unset pythonbrew
	pythonbrew_install

	if [[ -s "$HOME/.pythonbrew/etc/bashrc" ]]; then
		source "$HOME/.pythonbrew/etc/bashrc"
		default_ver=false

		for ver in $(cat .python-versions); do
			if [[ "*" == "${ver:0:1}" ]]; then
				ver=${ver:1}
				default_ver=$ver
			fi
			pythonbrew install $ver -j${MAKEJOBS}
		done

		if [ $default_ver ]; then
			pythonbrew switch $default_ver
		fi
	fi


	## Python Packages
	pythonbrew off 2>/dev/null
	for ii in `cat .python-packages`; do
		if [[ ! "$ii" ]]; then
			continue
		fi

		$SUDO pip install $ii
	done
}

_install_dotfiles () {
	pushd ~
	for ii in .zshrc .tmux.conf .vimrc .vim .gitconfig; do
		rm -f $ii
	done
	popd

	pushd $ENVPATH
	git submodule update --init --recursive
	popd

	ln -fs $ENVPATH/.zshrc ~/.zshrc
	ln -fs $ENVPATH/.tmux.conf ~/.tmux.conf
	ln -fs $ENVPATH/.vimrc ~/.vimrc
	ln -fs $ENVPATH/vim ~/.vim
	ln -fs $ENVPATH/.gitconfig-home ~/.gitconfig
}


PLATFORM=unknown
CORES=$(grep -c ^processor /proc/cpuinfo)
MAKEJOBS=$(expr $CORES - 1)
ENVPATH=$(cd $(dirname $0); pwd -P)
PKG_INSTALL_CMD=
PKG_REMOVE_CMD=

SYSPKG=false
SUDO=
PYTHONS=${SYSPKG}
CHANGEZSH=true

while getopts ":dbs" option
do
	case $option in
		i) SYSPKG=true;;
		s) SUDO="sudo";;
		p) PYTHONS=true;;
		z) CHANGEZSH=true;;
		*) echo "Unknown option $option"; exit 1;;
	esac
done

_detect_platform
_install_system
_install_syspackages
_install_python
_install_dotfiles

exit 0;

exit

if [ ${CHANGEZSH} ]; then
	RESULT=$($SUDO chsh -s $(which zsh) $USER)
	echo $RESULT
fi

