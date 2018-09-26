#!/usr/bin/env bash

git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	.zsh-syntax-highlighting

cd $HOME/.dotfiles
stow homedir
stow config
