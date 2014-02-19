swag () {
	local tmp_dir=/tmp
	local file_name=$(basename $1)
	local local_src="$1"
	local scp_target=swaghaus:.swag

	[[ $# -gt 1 ]] && file_name="$2"

	if [[ $1 =~ ^https?: ]]; then
		local_src="${tmp_dir}/${file_name}"
		curl -Ls $1 > $local_src
	fi

	scp $local_src ${scp_target}/${file_name}

	case $local_src in $tmp_dir*)
		rm -f $local_src ;;
	esac
}

