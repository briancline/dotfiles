#!/usr/bin/env bash
# This script prints a string will be evaluated for text attributes (but not shell commands) by tmux. It consists of a bunch of segments that are simple shell scripts/programs that output the information to show. For each segment the desired foreground and background color can be specified as well as what separator to use. The script the glues together these segments dynamically so that if one script suddenly does not output anything (= nothing should be shown) the separator colors will be nicely handled.

# The powerline root directory.
cwd=$(dirname $0)
tmuxpl=$(dirname $0)/../ext/tmux-powerline

# Source global configurations.
source "${cwd}/config.sh"

# Source lib functions.
source "${cwd}/lib.sh"

segments_path="${tmuxpl}/${segments_dir}"

# Segment
# Comment/uncomment the register function call to enable or disable a segment.

declare -A load
load+=(["script"]="${segments_path}/load.sh")
load+=(["foreground"]="colour167")
load+=(["background"]="colour237")
load+=(["separator"]="${separator_left_bold}")
register_segment "load"

declare -A datetime
datetime+=(["script"]="${cwd}/datetime.sh")
datetime+=(["foreground"]="colour136")
datetime+=(["background"]="colour235")
datetime+=(["separator"]="${separator_left_bold}")
register_segment "datetime"

# Print the status line in the order of registration above.
print_status_line_right

exit 0
