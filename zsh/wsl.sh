# This file is basically convenience stuff for my primary terminal at home, through
# Ubuntu on WSL2. It just sets my X display to the host machine, starts an SSH agent,
# and fires up terminator if it's not been started yet (I'm *always* using it).

export WSL_IP="$(ip addr | grep -E 'inet (172|192)' | awk '{print $2}' | cut -d/ -f1)"
export HOST_IP="$(ip ro | awk '/default via/{ print $3 }')"
export DISPLAY="${HOST_IP}:0.0"

echo "WSL IP:   ${WSL_IP}"
echo "Host IP:  ${HOST_IP}"
echo ""


# Start SSH agent
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


# Due to some changes in how WSL2 works, I can no longer just run a simple wsl command
# from the run prompt to start terminator in the background when I start Windows (the
# other alternative is to run from a command prompt window which then has to stick
# around until I no longer want to use terminator, which is obviously a bit dumb).
# I can't even just nohup it from said wsl command, either, which worked for a while.
# Instead, I have to start it with nohup, send to background, and disown it.
#
# Intuitive simplicity sometimes carries ridiculous costs. Terminator is worth it. :P

_terminator_pid=$(ps x | grep '[p]ython3 /usr/bin/terminator' | awk '{print $1}')
if [ -z "${_terminator_pid}" ]; then
    # Wrapped to hide the uncapturable shell output from backgrounding the process
    # (both hilarious and annoying since we actually need it for the disown job id)
    (nohup terminator >/dev/null 2>&1 &)
    job_id=$(jobs | grep 'nohup terminator' | awk '{print $1}' | sed -r 's/(\[|\])*//g' | head -n1)
    disown %${job_id} 2>/dev/null
fi

# If this is a new terminator-parented shell, force us to start in $HOME rather than our
# Windows %USERPROFILE% (dumb side effect of starting wsl shells from the run prompt).
if [[ "$(cat /proc/$PPID/comm)" =~ 'terminator' ]]; then
    echo "Yep"
    pushd -q $HOME
    dirs -c
fi
