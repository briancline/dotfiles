if [ -d "/opt/chef/embedded/bin" ]; then
    path_prepend "/opt/chef/embedded/bin"
    export ENV_NO_RVM=1
fi
