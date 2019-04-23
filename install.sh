#!/usr/bin/env bash

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_dir="${HOME}/.config/"

# install yay
if ! type yay; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepgk -si
fi

cd $script_home

# install dependencies
yay -S --needed - < packages.txt

# stow all modules
stow editor gui scripts terminal

git config --global core.excludesfile $config_dir/git/ignore
