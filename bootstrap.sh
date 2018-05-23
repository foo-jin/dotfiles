#!/usr/bin/env sh

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Update the dotfiles repo.
git pull

# Create new symlinks.
ln -sf $script_home/tmux.conf $HOME/.tmux.conf

mkdir -p .config/nvim/
ln -sf $script_home/vim/init.vim $HOME/.config/nvim/init.vim

mkdir -p .config/alacritty/
ln -sf $script_home/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

nvim +PluginInstall +UpdateRemotePlugins +qa
