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
deploy bin "$HOME" && hash -r
deploy_all_in data   "$XDG_DATA_HOME"
deploy_all_in config "$XDG_CONFIG_HOME"
[ -f ".gitconfig" ] && mv .gitconfig ".gitconfig.$TIME.bak"
cp "${DOT_ROOT}/config/git/template" "${DOT_ROOT}/config/git/config"
git config --global user.name "$git_name"
git config --global user.email "$git_email"

#
# CLI tools
#
brew_i zsh
if ! grep -xq "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "$password" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"
fi
echo "$password" | chsh -s $HOMEBREW_PREFIX/bin/zsh
mkdir -p "$XDG_STATE_HOME/zsh" && touch "$XDG_STATE_HOME/zsh/history"
git clone --depth 1 https://github.com/zdharma-continuum/zinit "${XDG_STATE_HOME}/zinit/zinit.git"

brew_i fzf
"${HOMEBREW_PREFIX}/opt/fzf/install" --xdg --completion --no-update-rc --no-key-bindings
brew_i cmake starship fd rg bat tree glow git-delta jq yq tmux navi hexyl tokei \
  ngrok direnv docker docker-compose gh act awscli aws-cdk

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
go_i github.com/x-motemen/gore/cmd/gore@latest

msg $'\ndeno:\n'
asdf plugin add deno     &&
asdf install deno latest &&
asdf global deno latest

msg $'\nnodejs:\n'
asdf plugin add nodejs
asdf list-all nodejs > /dev/null
asdf install nodejs lts &&
asdf global nodejs lts  &&
npm_i npm yarn pnpm
msg $'\n🍔  Installing bun:\n'
curl https://bun.sh/install | BUN_INSTALL="$XDG_STATE_HOME/bun" bash

msg $'\npython:\n'
asdf plugin add python
asdf install python 2.7.18
asdf install python 3.10.6 &&
asdf global python 3.10.6

msg $'\nphp:\n'
brew install php

msg $'\nmysql:\n'
asdf plugin-add mysql     &&
asdf install mysql 5.7.38 &&
asdf global mysql 5.7.38

msg $'\nlinters/formatters:\n'
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
msg $'\ninstalling neovim plugins...\n'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
msg $'\n\ninstalling treesitter parsers/language servers...\n'
timeout 300 nvim --headless
printf '\n'
pip3_i neovim-remote

asdf reshim

"$HOME/bin/chcs"

#
# OS-spesific settings
#
if is_mac; then
  brew_i binutils coreutils findutils grep gawk gnu-sed gnu-tar gzip wget gpg
  dotsync apply alt-tab
  dotsync apply rectangle
  git config --global credential.helper osxkeychain
fi

if is_wsl; then
  echo "$password" | dotsync -S apply wsl_conf >/dev/null
  if exists wslvar && exists wslpath; then
    # https://github.com/wslutilities/wslu/issues/199
    [ -d "$XDG_CONFIG_HOME/wslu" ] && echo 65001 > "$XDG_CONFIG_HOME/wslu/oemcp"
    dotsync apply espanso >/dev/null
    dotsync apply wezterm >/dev/null
    dotsync apply wslconfig >/dev/null
  fi

  curl -sLo /tmp/win32yank.zip \
    https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
  chmod +x /tmp/win32yank.exe
  mv /tmp/win32yank.exe ./bin

  git config --global credential.helper \
    "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
fi

longest="- chsh -s $HOMEBREW_PREFIX/bin/zsh (to set zsh to default shell)"
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
