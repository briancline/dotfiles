#!/usr/bin/env bash
#Print the status-left for tmux.
#
# The powerline root directory.
cwd=$(dirname $0)
tmuxpl=$(dirname $0)/../ext/tmux-powerline

# Source global configurations.
source "${cwd}/config.sh"
source "${cwd}/lib.sh"

segments_path="${tmuxpl}/${segments_dir}"

# Segments

echo ${cwd} >> /tmp/tpl

declare -A session_info
session_info+=(["script"]="${cwd}/session_info.sh")
session_info+=(["foreground"]="colour234")
session_info+=(["background"]="colour148")
session_info+=(["separator"]="${separator_right_bold}")
register_segment "session_info"

declare -A lan_ip
lan_ip+=(["script"]="${cwd}/lan_ip.sh")
lan_ip+=(["foreground"]="colour255")
lan_ip+=(["background"]="colour24")
lan_ip+=(["separator"]="${separator_right_bold}")
register_segment "lan_ip"

declare -A vcs_branch
vcs_branch+=(["script"]="${segments_path}/vcs_branch.sh")
vcs_branch+=(["foreground"]="colour88")
vcs_branch+=(["background"]="colour29")
vcs_branch+=(["separator"]="${separator_right_bold}")
register_segment "vcs_branch"

# Print the status line in the order of registration above.
print_status_line_left

exit 0
