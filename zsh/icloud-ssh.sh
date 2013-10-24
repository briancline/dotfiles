# Courtesy of <http://blog.joshdick.net/2012/08/10/ssh_via_icloud.html>.

# On Mac OS X, SSH to another Mac by hostname via Back To My Mac (iCloud)
# The client and target machines must both have Back To My Mac enabled
# Adapted from code found at
# <http://onethingwell.org/post/27835796928/remote-ssh-bact-to-my-mac>

function sshicloud() {
    if [[ $# -eq 0 || $# -gt 2 ]]; then
        echo "Usage: $0 computername [username]"
    elif ! hash "scutil" &> /dev/null; then
        echo "$0 only works on Mac OS X! Aborting."
    else
        local _icloud_addr=`echo show Setup:/Network/BackToMyMac \
                            | scutil \
                            | sed -n 's/.* : *\(.*\).$/\1/p'`
        local _username=`whoami`
        if [[ $# -eq 2 ]]; then
            _username=$2
        fi
        ssh $_username@$1.$_icloud_addr
    fi
}
