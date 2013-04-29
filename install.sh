#!/bin/bash
PLATFORM=unknown
CORES=$(grep -c ^processor /proc/cpuinfo)
MAKEJOBS=$(expr $CORES - 1)
ENVPATH=$(cd $(dirname $0); pwd -P)
PKG_INSTALL_CMD=
PKG_REMOVE_CMD=
SUDO=sudo

SYSPKG=false
PYTHON=${SYSPKG}
CHANGEZSH=false

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
	$SUDO $ENVPATH/.system-$PLATFORM
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
		default_ver=

		for ver in $(cat .python-versions); do
			if [[ "*" == "${ver:0:1}" ]]; then
				ver=${ver:1}
				default_ver=$ver
			fi
			pythonbrew install $ver -j${MAKEJOBS}
		done

		[[ -n "$default_ver" ]] && pythonbrew switch $default_ver
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
	for ii in .zshrc .tmux.conf .vimrc .vim .irssi .gitconfig; do
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
	ln -fs $ENVPATH/.irssi ~/.irssi
	ln -fs $ENVPATH/.gitconfig-home ~/.gitconfig
}


while getopts ":hspz" option
do
	case $option in
		h) echo "Usage: $0 [-h] [-s] [-p] [-z]"
		   echo "  -h   Displays help"
		   echo "  -s   Sets up base system"
		   echo "  -p   Installs Python packages and PythonBrew"
		   echo "  -z   Changes shell to zsh"
		   exit 0;;

		s) SYSPKG=true;;
		p) PYTHON=true;;
		z) CHANGEZSH=true;;
		*) echo "Unknown option $option"; exit 1;;
	esac
done

_detect_platform
$SYSPKG && _install_system
$SYSPKG && _install_syspackages
$PYTHON && _install_python
_install_dotfiles

ZSH_PATH=$(which zsh)
if [[ $CHANGEZSH ]] && [[ -n "$ZSH_PATH" ]]; then
	RESULT=$($SUDO chsh -s $(which zsh) $USER)
	echo $RESULT
fi
