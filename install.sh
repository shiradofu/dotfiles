#!/bin/bash
# shellcheck disable=SC2317

password=$1
git_name=$2
git_email=$3

msg()    { printf "\033[1;34m%s\033[0m\n" "$1"; }
err()    { printf "\033[1;31m%s\033[0m\n" "$1" 1>&2; return 1; }
exists() { type "$1" > /dev/null 2>&1; }
is_mac() { echo "$OSTYPE" | grep darwin -q; }
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
_brew()  { msg $'\n🍺  Installing '"$1"$':\n'; brew install "$X"; }
_mise()  { msg $'\n💧  Installing '"$1"$':\n'; mise use -g "$X"; }

DOT_ROOT=$(cd "$(dirname "$0")" && pwd)
source "$DOT_ROOT/config/zsh/.zshenv"
TIME=$(date "+%F-%H%M%S")

#
# Deploy files
#
"$DOT_ROOT/bin/dotdeploy" --backup-subdir="$TIME" bin "$HOME" && hash -r
dotdeploy --backup-subdir="$TIME" config/zsh/.zshenv "$HOME"
dotdeploy --backup-subdir="$TIME" --all-in data   "$XDG_DATA_HOME"
dotdeploy --backup-subdir="$TIME" --all-in config "$XDG_CONFIG_HOME"

[ -f "$HOME/.gitconfig" ] && \
  dotdeploy --backup-subdir="$TIME" --backup-only "$HOME/.gitconfig"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.name  "$git_name"
git config --file "${XDG_CONFIG_HOME}/git/user.gitconfig" user.email "$git_email"

#
# Zsh
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

#
# Vim
#
_brew vim
_brew nvim
_brew neovim-remote
mkdir -p "$XDG_CACHE_HOME"/vim/{undo,swap,backup}
git clone --filter=blob:none --branch=stable \
  https://github.com/folke/lazy.nvim.git \
  "$XDG_DATA_HOME/nvim/lazy/lazy.nvim"

msg $'\nInstalling neovim plugins...\n'
nvim --headless "+Lazy! sync" +qa

msg $'\n\nInstalling Treesitter Parsers...\n'
timeout 120 nvim --headless +TSUpdateSync
printf '\n'

#
# Docker
#
_brew docker
_brew docker-buildx
_brew docker-compose
_brew lazydocker
# https://github.com/abiosoft/colima/discussions/273
mkdir -p "$DOCKER_CONFIG/cli-plugins"
ln -sfn "$(which docker-compose)" "$DOCKER_CONFIG/cli-plugins/docker-compose"
ln -sfn "$(which docker-buildx)" "$DOCKER_CONFIG/cli-plugins/docker-buildx"
docker buildx install

#
# CLI Tools
#
_brew fzf
"${HOMEBREW_PREFIX}/opt/fzf/install" \
  --xdg --completion --no-update-rc --no-key-bindings

_brew act
_brew aws-cdk
_brew aws-sam-cli
_brew awscli
_brew bat
_brew cmake
_brew dateutils
_brew direnv
_brew fd
_brew gcc
_brew gh
_brew git-delta
_brew hyperfine
_brew jq
_brew marp-cli
_brew navi
_brew protobuf
_brew rg
_brew protoc-gen-go
_brew starship
_brew tmux
_brew tokei
_brew tree
_brew yarn
_brew yazi
_brew yq

#
# Languages and Tools
#
_brew gcc
_brew llvm
_brew mise

_mise rust
rustup component add rust-analyzer

_mise go
_mise golangci-lint
_brew protoc-gen-go

_mise node@lts
_mise deno
_mise yarn
_mise pnpm
_mise bun
_mise npm:@wordpress/env
_mise npm:npm-check-updates

_mise python

_mise lua-language-server
_mise stylua

_mise ruby
_brew php
_brew composer

msg $'\nsetting colorscheme:'
chcs --no-os

#
# Environment-spesific settings
#
if is_mac; then "$DOT_ROOT/env/mac/install.sh" "$password"; fi
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
