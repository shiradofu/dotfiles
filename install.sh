#!/bin/bash

password=$1

msg() { printf "\033[1;34m$1\033[0m\n"; }
exists() { type $1 > /dev/null 2>&1; }
is_mac() { uname | grep Darwin -q; }
is_wsl() { uname -r | grep microsoft -q; }
brew_i() { msg "\n🍺  installing $1:\n"; brew install $1; }
npm_i()  { msg "\n🍔  installing $1:\n"; npm install -g $1; }
go_i()   { msg "]n🍙  installing $1:\n"; go install $1 }

DOTFILES_ROOT=$(cd $(dirname $0) && pwd)
source ${DOTFILES_ROOT}/.config/zsh/.zshenv

brew_i zsh
if ! cat /etc/shells | grep -xq ${HOMEBREW_PREFIX}/bin/zsh; then
  echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
fi
mkdir -p "$XDG_STATE_HOME/zsh" && touch "$XDG_STATE_HOME/zsh/history"
git clone --depth 1 https://github.com/zdharma-continuum/zinit "${XDG_STATE_HOME}/zinit/zinit.git"

brew_i fzf
${HOMEBREW_PREFIX}/opt/fzf/install --completion --no-update-rc --no-key-bindings --xdg

brew_i rg
brew_i fd
brew_i jq
brew_i bat
brew_i tmux
brew_i hexyl
brew_i git
brew_i git-delta
brew_i gh
brew_i gitui
brew_i tokei
brew_i act
brew_i awscli
brew_i cmake

msg "\n🚀 installing starship:\n"
curl -sS https://starship.rs/install.sh | sh -s -- --yes

#
# Languages and Package Managers
#
msg "\nc/c++:\n"
brew_i gcc
brew_i llvm

git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
git -C "$ASDF_DIR" checkout -q "$(git -C $ASDF_DIR describe --abbrev=0 --tags)"
source "$ASDF_DIR/asdf.sh"

msg "\ngolang:\n"
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
go_i golang.org/x/tools/cmd/goimports@latest

msg "\ndeno:\n"
asdf plugin add deno     &&
asdf install deno latest &&
asdf global deno latest

msg "\nnodejs:\n"
asdf plugin add nodejs  &&
asdf install nodejs lts &&
asdf global nodejs lts  &&
npm install --global npm
brew_i yarn

msg "\npython:\n"
brew install openssl readline sqlite3 xz zlib &&
asdf plugin add python     &&
asdf install python 2.7.18 &&
asdf install python 3.10.4 &&
asdf global python 3.10.4

msg "\nphp:\n"
brew_i php
brew_i composer

msg "\ndirenv:\n"
asdf plugin add direnv     &&
asdf install direnv latest &&
asdf global direnv latest

mgs "\nlinters/formatters:\n"
brew_i stylua
brew_i shellcheck
brew_i cfn-lint
brew_i actionlint
npm_i eslint_d
npm_i @fsouza/prettierd
npm_i stylelint
go_i github.com/editorconfig-checker/editorconfig-checker/cmd/editorconfig-checker@latest

#
# Vim
#
brew_i vim
brew_i nvim
npm install --global neovim

# curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.sh
# vim_plugin_dir=$XDG_STATE_HOME/nvim/dein
# mkdir -p "${vim_plugin_dir}"
# sh ./dein.sh "${vim_plugin_dir}"

git clone --depth 1 \
  https://github.com/wbthomason/packer.nvim \
  $XDG_DATA_HOME/nvim/site/pack/packer/opt/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


#
# Deploy files
#
cd
set -e
RAND=$RANDOM
[ -f ".zshenv" ] && mv .zshenv .zshenv.${RAND}.bak
ln -s ${DOTFILES_ROOT}/.config/zsh/.zshenv
[ -d ".config" ] && mv .config .config.${RAND}.bak
ln -s ${DOTFILES_ROOT}/.config
[ -d "bin" ] && mv bin bin.${RAND}.bak
ln -s ${DOTFILES_ROOT}/bin && hash -r
[ -f ".gitconfig" ] && mv .gitconfig .gitconfig.${RAND}.bak
cp ${DOTFILES_ROOT}/.config/git/config.tpl ${DOTFILES_ROOT}/.config/git/config

if ! [ -f ".bashrc" ] || ! cat .bashrc | grep -xq 'source ~/.zshenv'; then
  echo 'source ~/.zshenv' >> .bashrc
fi

#
# OS-spesific settings
#
if is_mac; then
  brew_i binutils
  brew_i coreutils
  brew_i findutils
  brew_i grep
  brew_i gawk
  brew_i gnu-sed
  brew_i gnu-tar
  brew_i gzip
  brew_i wget
  brew_i gpg

  git config --global credential.helper osxkeychain
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
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
