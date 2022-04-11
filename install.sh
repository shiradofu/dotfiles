#!/bin/bash

msg() { printf "\033[1;34m$1\033[0m\n"; }
is_mac() { uname | grep Darwin -q; }
is_wsl() { uname -r | grep microsoft -q; }
exists() { type $1 > /dev/null 2>&1; }
brew-install() { msg "\n🍺  installing $1...\n"; brew install $1; }
source ${SCRIPT_DIR}/../.config/zsh/.zshenv
SCRIPT_DIR=$(cd $(dirname $0) && pwd)
password=$1

msg "🍺  installing formulae with homebrew..."

brew-install zsh
brew-install fzf
brew-install rg
brew-install fd
brew-install jq
brew-install bat
brew-install tmux
brew-install starship
brew-install nvim
brew-install git
brew-install git-delta
brew-install gh
brew-install ghq
brew-install gitui
brew-install tokei
brew-install act
brew-install awscli
brew-install bitwarden-cli
brew-install asdf
brew-install watchman # for coc-tsserver

echo "$1" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
$(brew --prefix)/opt/fzf/install --completion --no-update-rc --xdg


# msg "\n🍺  brew install completed!"

msg "\ninstall languages...\n"

source ${HOMEBREW_PREFIX}/opt/asdf/asdf.sh

brew-install llvm
brew-install ccls

msg "\nnodejs:\n"
asdf plugin add nodejs  &&
asdf install nodejs lts &&
asdf global nodejs lts  &&
npm install --global neovim
brew-install yarn

asdf plugin add yarn     &&
asdf install yarn latest &&
asdf global yarn latest

msg "\npython:\n"
asdf plugin add python     &&
asdf install python 2.7.18 &&
asdf shell python 2.7.18   &&
pip install pynvim

asdf install python 3.9.6  &&
asdf shell python 3.9.6    &&
pip install pynvim         &&
asdf global python 3.9.6

pip3 install neovim-remote &&
asdf reshim python

msg "\ngolang:\n"
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
export GOPATH="$XDG_CACHE_HOME/go"
go install golang.org/x/tools/cmd/goimports@latest

brew-install php
brew-install composer

# set -e

# ghq_shiradofu=$(ghq root)/github.com/shiradofu
# mkdir -p $ghq_shiradofu
# rsync -av ./dotfiles $ghq_shiradofu/
# ghq_dotfiles=$ghq_shiradofu/dotfiles

# [ -f ".zshenv" ] && mv .zshenv .zshenv.$RANDOM.bak
# ln -s $ghq_dotfiles/.config/zsh/.zshenv
# [ -d ".config" ] && mv .config .config.$RANDOM.bak
# ln -s $ghq_dotfiles/.config
# [ -d "bin" ] && mv bin bin.$RANDOM.bak
# ln -s $ghq_dotfiles/bin && hash -r
# [ -f ".gitconfig" ] && mv .gitconfig .gitconfig.$RANDOM.bak
# cp $ghq_dotfiles/.config/git/config.tpl $ghq_dotfiles/.config/git/config

# if ! [ -f ".bashrc" ] || ! cat .bashrc | grep -xq 'source ~/.zshenv'; then
#   echo 'source ~/.zshenv' >> .bashrc
# fi

# chcs iceberg

# if is_mac; then
#   # brew install もこっちに持ってくる
#   git config --global credential.helper osxkeychain
#   defaults write com.apple.Dock autohide-delay -float 3600; killall Dock
# fi

# if is_wsl && exists wslvar; then
#   curl -sLo /tmp/win32yank.zip \
#     https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
#   unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
#   chmod +x /tmp/win32yank.exe
#   mv /tmp/win32yank.exe ./bin

#   userprofile=$(wslpath $(wslvar USERPROFILE))
#   wslsync .wslconfig
#   wslsync wls.conf --password $password
#   winterm-gen --colorscheme Iceberg
#   wslsync winterm

#   git config --global credential.helper \
#     "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
# fi

# unset $password
