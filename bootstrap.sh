#!/usr/bin/env sh

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

link_config () {
    ln -sf $script_home/$1 $config_dir
}

# Create new symlinks.
ln -sf $script_home/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $script_home/xdg/user-dirs.dirs $config_dir/user-dirs.dirs
link_config fish
link_config alacritty
link_config i3
link_config polybar
link_config git
git config --global core.excludesfile $config_dir/git/ignore

mkdir -p $config_dir/nvim/
ln -sf $script_home/vim/init.vim $config_dir/nvim/init.vim
