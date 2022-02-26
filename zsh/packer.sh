if [ -d "/opt/packer" ]; then
    path_append "/opt/packer"
fi

if [ -d "$HOME/app/packer" ]; then
    path_append "${HOME}/app/packer"
fi
