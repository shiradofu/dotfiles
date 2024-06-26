#!/bin/bash
# shellcheck disable=SC1091

password=$1
git_name=$2
git_email=$3

i=0
msg()    { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
err()    { printf "\033[1;31m%s\033[0m\n" "$1" 1>&2; return 1; }
exists() { type "$1" > /dev/null 2>&1; }
is_mac() { echo "$OSTYPE" | grep darwin -q; }
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
brew_i() { for X; do msg $'\n🍺  Installing '"$X"$':\n'; brew install "$X"; done }
npm_i()  { for X; do msg $'\n🍔  Installing '"$X"$':\n'; npm install -g "$X"; done }
go_i()   { for X; do msg $'\n🍙  Installing '"$X"$':\n'; go install "$X"; done }
pip3_i() { for X; do msg $'\n🧪  Installing '"$X"$':\n'; pip3 install "$X"; done }

DOT_ROOT=$(cd "$(dirname "$0")" && pwd)
source "$DOT_ROOT/config/zsh/.zshenv"
TIME=$(date "+%F-%H%M")

# $1: relative path from dotfiles repo root
# $2: directory where symlink will be created
deploy() {
  fullpath="$DOT_ROOT/$1"
  basename="$(basename "$1")"
  linkname="$2/$basename"
  if [ -e "$linkname" ]; then
    mv "$linkname" "$linkname.$TIME.bak";
    echo "backed up $linkname"
  fi
  ln -s "$fullpath" "$linkname"
  echo "deployed  $linkname"
}
# $1: 'config' or 'data'
# $2: directory where symlink will be created
deploy_all_in() {
  [ -e "$2" ] && [ ! -d "$2" ] && mv "$2" "$2.$TIME.bak"
  mkdir -p "$2"
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
deploy config/vim/.vimrc "$HOME"
deploy bin "$HOME" && hash -r
deploy_all_in data   "$XDG_DATA_HOME"
deploy_all_in config "$XDG_CONFIG_HOME"
[ -f ".gitconfig" ] && mv .gitconfig ".gitconfig.$TIME.bak"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.name "$git_name"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.email "$git_email"

#
# CLI tools
#
msg $'\n🍺  Installing zsh:\n'
expect -c "
  set timeout -1
  spawn brew install zsh
  expect \"\[Pp\]assword\"
  send -- \"${password}\n\"
"
if ! grep -xq "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
fi
echo "$password" | chsh -s "$HOMEBREW_PREFIX/bin/zsh" >/dev/null 2>&1
mkdir -p "$XDG_STATE_HOME/zsh" && touch "$XDG_STATE_HOME/zsh/history"
git clone --depth 1 https://github.com/zdharma-continuum/zinit "${XDG_STATE_HOME}/zinit/zinit.git"

brew_i fzf
"${HOMEBREW_PREFIX}/opt/fzf/install" --xdg --completion --no-update-rc --no-key-bindings
brew_i cmake starship fd rg bat tree glow git-delta jq yq tmux navi hyperfine tokei \
  direnv gh act awscli aws-cdk aws-sam-cli \
  marp-cli mackup tako8ki/tap/gobang

#
# Languages and Package Managers
#
msg $'\nc/c++:\n'
brew_i gcc llvm

git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
git -C "$ASDF_DIR" checkout -q "$(git -C "$ASDF_DIR" describe --abbrev=0 --tags)"
source "$ASDF_DIR/asdf.sh"

msg $'\ngolang:\n'
asdf plugin add golang     &&
asdf install golang latest &&
asdf global golang latest
go_i golang.org/x/tools/cmd/goimports@latest
go_i google.golang.org/protobuf/cmd/protoc-gen-go@latest

msg $'\ndeno:\n'
asdf plugin add deno     &&
asdf install deno latest &&
asdf global deno latest

msg $'\nnodejs:\n'
asdf plugin add nodejs
asdf list-all nodejs > /dev/null
asdf install nodejs "$(asdf nodejs resolve lts --latest-available)" &&
asdf global nodejs "$(asdf nodejs resolve lts --latest-available)"   &&
npm_i npm yarn pnpm npm-check-updates
msg $'\n🍔  Installing bun:\n'
# SHELL='' は zshrc の自動アップデート防止のため
curl https://bun.sh/install | BUN_INSTALL="$XDG_STATE_HOME/bun" SHELL='' bash

msg $'\npython:\n'
asdf plugin add python
asdf install python 2.7.18
asdf install python latest &&
asdf global python latest
pip3 install --upgrade pip

msg $'\nphp:\n'
brew install php composer

msg $'\ndocker:\n'
brew_i docker docker-buildx docker-compose lazydocker
# https://github.com/abiosoft/colima/discussions/273
mkdir -p "$DOCKER_CONFIG/cli-plugins"
ln -sfn "$(which docker-compose)" "$DOCKER_CONFIG/cli-plugins/docker-compose"
ln -sfn "$(which docker-buildx)" "$DOCKER_CONFIG/cli-plugins/docker-buildx"
docker buildx install

msg $'\nlinters/formatters:\n'
# installed with mason.nvim doesn't support Apple Silicon
# TODO: check necessity
brew_i golangci-lint

msg $'\nmisc:\n'
brew_i protobuf

#
# Vim
#
brew_i vim nvim neovim-remote
mkdir -p "$XDG_CACHE_HOME"/vim/{undo,swap,backup}
git clone --filter=blob:none --branch=stable \
  https://github.com/folke/lazy.nvim.git \
  "$XDG_DATA_HOME/nvim/lazy/lazy.nvim"
msg $'\nInstalling neovim plugins...\n'
nvim --headless "+Lazy! sync" +qa
msg $'\n\nInstalling Treesitter Parsers...\n'
timeout 120 nvim --headless +TSUpdateSync
msg $'\nInstalling Language Servers...\n'
timeout 120 nvim --headless "+lua require('mason-lspconfig.ensure_installed')()"
msg $'\nInstalling Linting/Formatting tools...\n'
timeout 60 nvim --headless "+lua require('mason-null-ls.ensure_installed')()"
printf '\n'

msg $'\nasdf reshim:'
asdf reshim && printf "ok\n" || printf "failed\n"

msg $'\nsetting colorscheme:'
"$HOME/bin/chcs" --no-os

#
# Environment-spesific settings
#
if is_mac; then "$DOT_ROOT/env/mac/install.sh"; fi
if is_wsl; then "$DOT_ROOT/env/wsl/install.sh" "$password"; fi

longest="- $HOMEBREW_PREFIX/bin/zsh (to install plugins)"
printf '\n\n\n '
printf "%${#longest}s==\n\n" | tr " " "="
printf '  👏  \033[1;32mInstallation successfully completed! \033[0m\n\n'
cat << EOF
  What to do next:

  - $HOMEBREW_PREFIX/bin/zsh (to install plugins)
  - aws configure (access key is required)
  - gh auth login
EOF
printf '\n '
printf "%${#longest}s==\n\n" | tr " " "="

unset password
