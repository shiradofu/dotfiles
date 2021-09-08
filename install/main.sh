#!/bin/bash

msg() { printf "\033[1;34m$1\033[0m\n"; }
is_mac() { uname | grep Darwin -q; }
is_wsl() { uname -r | grep microsoft -q; }
exists() { type $1 > /dev/null 2>&1; }

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
password=$1

source ${SCRIPT_DIR}/../.config/zsh/.zshenv
source ${SCRIPT_DIR}/homebrew.sh $password
source ${SCRIPT_DIR}/languages.sh

set -e

ghq_shiradofu=$(ghq root)/github.com/shiradofu
mkdir -p $ghq_shiradofu
rsync -av ./dotfiles $ghq_shiradofu/
ghq_dotfiles=$ghq_shiradofu/dotfiles

[ -f ".zshenv" ] && mv .zshenv .zshenv.$RANDOM.bak
ln -s $ghq_dotfiles/.config/zsh/.zshenv
[ -d ".config" ] && mv .config .config.$RANDOM.bak
ln -s $ghq_dotfiles/.config
[ -d "bin" ] && mv bin bin.$RANDOM.bak
ln -s $ghq_dotfiles/bin && hash -r
[ -f ".gitconfig" ] && mv .gitconfig .gitconfig.$RANDOM.bak
cp $ghq_dotfiles/.config/git/config.tpl $ghq_dotfiles/.config/git/config

if ! [ -f ".bashrc" ] || ! cat .bashrc | grep -xq 'source ~/.zshenv'; then
  echo 'source ~/.zshenv' >> .bashrc
fi

chcs iceberg

if is_wsl && exists wslvar; then
  curl -sLo /tmp/win32yank.zip \
    https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
  chmod +x /tmp/win32yank.exe
  mv /tmp/win32yank.exe ./bin

  userprofile=$(wslpath $(wslvar USERPROFILE))
  wslsync .wslconfig
  wslsync wls.conf --password $password
  winterm-gen --colorscheme Iceberg
  wslsync winterm
fi

unset $password
