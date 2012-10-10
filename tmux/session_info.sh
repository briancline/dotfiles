#!/usr/bin/env sh
TMUX=`tmux display-message -p '#S:#I.#P'`
HOST=`hostname -f`
HOST=${HOST%.*.*}
echo "${TMUX}@${HOST}"

exit 0
