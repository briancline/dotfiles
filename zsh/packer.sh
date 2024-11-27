if [ -d "/opt/packer" ]; then
    path_append "/opt/packer"
fi

if [ -d "$HOME/opt/packer" ]; then
    path_append "${HOME}/opt/packer"
fi
