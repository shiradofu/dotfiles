#!/bin/bash

msg() { printf "\033[1;34m$1\033[0m\n"; }
is_mac() { uname | grep Darwin -q; }
exists() { type $1 > /dev/null 2>&1; }

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

source ${SCRIPT_DIR}/../.config/zsh/.zshenv
source ${SCRIPT_DIR}/homebrew.sh $1
source ${HOMEBREW_PREFIX}/opt/asdf/asdf.sh
source ${SCRIPT_DIR}/languages.sh

ghq_shiradofu=$(ghq root)/github.com/shiradofu/
mkdir -p $ghq_shiradofu
cp -r dotfiles $ghq_shiradofu
ghq_dotfiles=$ghq_shiradofu/dotfiles

[ -f ".zshenv" ] && mv .zshenv .zshenv.$RANDOM.bak
ln -s $ghq_dotfiles/.config/zsh/.zshenv
[ -d ".config" ] && mv .config .config.$RANDOM.bak
ln -s $ghq_dotfiles/.config
[ -d "bin" ] && mv bin bin.$RANDOM.bak
ln -s $ghq_dotfiles/bin
[ -f ".gitconfig" ] && mv .gitconfig .gitconfig.$RANDOM.bak
cp $ghq_dotfiles/.config/git/config.tpl $ghq_dotfiles/.config/git/config

if ! [ -f ".bashrc" ] || ! cat .bashrc | grep -xq 'source ~/.zshenv'; then
  echo 'source ~/.zshenv' >> .bashrc
fi
