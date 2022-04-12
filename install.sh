#!/bin/bash

password=$1

msg() { printf "\033[1;34m$1\033[0m\n"; }
exists() { type $1 > /dev/null 2>&1; }
is_mac() { uname | grep Darwin -q; }
is_wsl() { uname -r | grep microsoft -q; }
brew-i() { msg "\n🍺  installing $1:\n"; brew install $1; }

source ${SCRIPT_DIR}/../.config/zsh/.zshenv
SCRIPT_DIR=$(cd $(dirname $0) && pwd)

brew-i zsh
echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"

brew-i fzf
${HOMEBREW_PREFIX}/opt/fzf/install --completion --no-update-rc --xdg

brew-i rg
brew-i fd
brew-i jq
brew-i bat
brew-i tmux
brew-i starship
brew-i git
brew-i git-delta
brew-i gh
brew-i ghq
brew-i gitui
brew-i tokei
brew-i act
brew-i awscli
brew-i bitwarden-cli

#
# Languages and Package Managers
#
brew-i asdf
source ${HOMEBREW_PREFIX}/opt/asdf/asdf.sh

msg "\nc/c++:\n"
brew-i gcc
brew-i llvm
brew-i ccls

msg "\ngolang:\n"
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
go install golang.org/x/tools/cmd/goimports@latest

msg "\nnodejs:\n"
asdf plugin add nodejs  &&
asdf install nodejs lts &&
asdf global nodejs lts  &&
brew-i yarn

msg "\npython:\n"
asdf plugin add python     &&
asdf install python 2.7.18 &&

asdf install python 3.9.6  &&
asdf global python 3.9.6

msg "\nphp:\n"
brew-i php
brew-i composer

#
# Vim
#
brew-i nvim
npm install --global neovim
asdf shell python 2.7.18 && pip install pynvim
asdf shell python 3.9.6  && pip install pynvim
brew-i watchman # coc-tsserver

#
# Deploy files
#
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

#
# OS-spesific settings
#
if is_mac; then
  git config --global credential.helper osxkeychain
  defaults write com.apple.Dock autohide-delay -float 3600; killall Dock
fi

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

  git config --global credential.helper \
    "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
fi

unset $password
