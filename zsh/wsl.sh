export DISPLAY=:0

SSH_AGENT_FILE=~/.tmp-sshagent.rc

start_ssh_agent() {
    echo >&1 "Starting new SSH agent."
    touch ${SSH_AGENT_FILE}
    chmod 600 ${SSH_AGENT_FILE}
    ssh-agent > ${SSH_AGENT_FILE}
    source ${SSH_AGENT_FILE} >/dev/null
    ssh-add $(grep -El 'BEGIN [A-Z]+ PRIVATE KEY' ~/.ssh/*)
}

if [ ! -f ${SSH_AGENT_FILE} ]; then
    start_ssh_agent
else
    source ${SSH_AGENT_FILE} >/dev/null
    if ! kill -0 ${SSH_AGENT_PID} >/dev/null 2>&1 ; then
        start_ssh_agent
    fi
fi

