#!/usr/bin/env sh

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# hard link scripts
mkdir -p $HOME/bin
ln -f $script_home/bin/* $HOME/bin/

# xdg directory spec
ln -f $script_home/xdg/user-dirs.dirs $config_dir/user-dirs.dirs

# tmux
ln -f $script_home/tmux/tmux.conf $HOME/.tmux.conf

# xbindkeys
ln -f $script_home/xbindkeys/xbindkeysrc $config_dir/xbindkeysrc

# systemd user units
mkdir -p $config_dir/systemd/user
ln -f $scrip_home/systemd/* $config_dir/systemd/user

link_dir() {
    mkdir -p $config_dir/$1
    ln -f $script_home/$1/* $config_dir/$1/
}

# neovim
link_dir nvim

# fish
link_dir fish/functions
ln -f $script_home/fish/config.fish $config_dir/fish/config.fish

# alacritty
link_dir alacritty

# i3
link_dir i3

# polybar
link_dir polybar

# redshift
link_dir redshift

# git
link_dir git
git config --global core.excludesfile $config_dir/git/ignore
