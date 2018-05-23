#!/usr/bin/env sh

export DOTFILES=$HOME/dev/dotfiles
# Remove old config dirs and files.
cd
rm -rf $DOTFILES .config/nvim/ .config/alacritty/
rm -rf .tmux.conf

# Clone dotfiles repo.
git clone --quiet https://github.com/mauroporrasp/dotfiles.git

# Create new symlinks.
mkdir -p .config/nvim/
ln -s $DOTFILES/vim/init.vim ~/.config/nvim/init.vim

mkdir -p .config/alacritty/
ln -s $DOTFILES/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

ln -s $DOTFILES/tmux.conf ~/.tmux.conf

# Start Neovim.
echo 'Starting Neovim'
nvim +PluginInstall +UpdateRemotePlugins +qa
