#!/bin/bash
# shellcheck disable=SC1091

password=$1

i=0
msg()    { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
exists() { type "$1" > /dev/null 2>&1; }
is_mac() { echo "$OSTYPE" | grep darwin -q; }
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
brew_i() { for X; do msg "\n🍺  Installing $X:\n"; brew install "$X"; done }
npm_i()  { for X; do msg "\n🍔  Installing $X:\n"; npm install -g "$X"; done }
go_i()   { for X; do msg "]n🍙  Installing $X:\n"; go install "$X"; done }

DOT_ROOT=$(cd "$(dirname "$0")" && pwd)
source "$DOT_ROOT/.config/zsh/.zshenv"
TIME=$(date "+%F-%H-%M")

# $1: relative path from dotfiles repo root
# $2: directory where symlink will be created
deploy() {
  fullpath="$DOT_ROOT/$1"
  basename="$(basename "$1")"
  linkname="$2/$basename"
  [ -d "$2" ] || mkdir -p "$2"
  if [ -e "$linkname" ]; then
    echo "$linkname backup created"
    mv "$linkname" "$linkname.$TIME.bak";
  fi
  ln -s "$fullpath" "$linkname"
  echo "$linkname backup deployed"
}
# $1: 'config' or 'data'
# $2: directory where symlink will be created
deploy_all_in() {
  for d in "$DOT_ROOT/$1"/*; do
    if [ -d "$d" ]; then
      deploy "$1/$(basename "$d")" "$2"
    fi
  done
}

#
# Deploy files
#
deploy config/zsh/.zshenv "$HOME"
deploy bin "$HOME" && hash -r
deploy_all_in data   "$XDG_DATA_HOME"
deploy_all_in config "$XDG_CONFIG_HOME"
[ -f ".gitconfig" ] && mv .gitconfig ".gitconfig.$TIME.bak"
cp "${DOT_ROOT}/.config/git/template" "${DOT_ROOT}/.config/git/config"

#
# CLI tools
#
brew_i zsh
if ! grep -xq "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
fi
mkdir -p "$XDG_STATE_HOME/zsh" && touch "$XDG_STATE_HOME/zsh/history"
git clone --depth 1 https://github.com/zdharma-continuum/zinit "${XDG_STATE_HOME}/zinit/zinit.git"
zsh -i -c exit > /dev/null 2>&1

brew_i fzf
"${HOMEBREW_PREFIX}/opt/fzf/install" --xdg --completion --no-update-rc --no-key-bindings
brew_i cmake starship fd rg bat glow git-delta jq tmux navi hexyl tokei \
  direnv docker gh act awscli

#
# Languages and Package Managers
#
msg "\nc/c++:\n"
brew_i gcc llvm

git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
git -C "$ASDF_DIR" checkout -q "$(git -C "$ASDF_DIR" describe --abbrev=0 --tags)"
source "$ASDF_DIR/asdf.sh"

msg "\ngolang:\n"
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
go_i golang.org/x/tools/cmd/goimports@latest
go_i github.com/x-motemen/gore/cmd/gore@latest

msg "\ndeno:\n"
asdf plugin add deno     &&
asdf install deno latest &&
asdf global deno latest

msg "\nnodejs:\n"
asdf plugin add nodejs  &&
asdf install nodejs lts &&
asdf global nodejs lts  &&
npm_i npm yarn pnpm

msg "\npython:\n"
brew install openssl readline sqlite3 xz zlib &&
asdf plugin add python     &&
asdf install python 2.7.18 &&
asdf install python 3.10.4 &&
asdf global python 3.10.4

msg "\nphp:\n"
# deps from https://github.com/asdf-community/asdf-php/blob/master/.github/workflows/workflow.yml
brew install autoconf automake bison freetype gd gettext icu4c krb5 libedit libiconv libjpeg libpng libxml2 libzip openssl@1.1 pkg-config re2c zlib
if is_mac; then brew install gmp libsodium imagemagick; fi
asdf plugin add php &&
asdf install php latest &&
asdf global php latest

msg "\ndirenv:\n"
asdf plugin add direnv     &&
asdf install direnv latest &&
asdf global direnv latest

msg "\nmysql:\n"
asdf plugin-add mysql     &&
asdf install mysql 5.7.38 &&
asdf global mysql

mgs "\nlinters/formatters:\n"
brew_i stylua shellcheck cfn-lint actionlint
npm_i eslint_d @fsouza/prettierd stylelint
go_i github.com/editorconfig-checker/editorconfig-checker/cmd/editorconfig-checker@latest

#
# Vim
#
brew_i vim nvim
git clone --depth 1 \
  https://github.com/wbthomason/packer.nvim \
  "$XDG_DATA_HOME/nvim/site/pack/packer/opt/packer.nvim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
pip3 install neovim-remote
asdf reshim

"$HOME/chcs"

#
# OS-spesific settings
#
if is_mac; then
  brew_i binutils coreutils findutils grep gawk gnu-sed gnu-tar gzip wget gpg
  git config --global credential.helper osxkeychain
fi

if is_wsl && exists wslvar; then
  curl -sLo /tmp/win32yank.zip \
    https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
  chmod +x /tmp/win32yank.exe
  mv /tmp/win32yank.exe ./bin

  dotsync backup wslconfig
  dotsync apply wslconfig
  dotsync --password "$password" backup wsl_conf
  dotsync --password "$password" apply wsl_conf

  git config --global credential.helper \
    "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
fi

unset password
