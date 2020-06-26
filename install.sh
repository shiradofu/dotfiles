#!/bin/sh

NC="\033[0m"
ok_m()    { printf "\033[1;32m$1\n${NC}"; }                # green
err_m()   { printf "\033[1;31m$1\n${NC}" 1>&2; return 1; } # red
info_m()  { printf "\033[1;34m$1\n${NC}"; }                # blue
other_m() { printf "\033[1;35m$1\n${NC}"; }                # purple
exists()  { type $1 > /dev/null 2>&1; }
required() if ! exists $1; then err_m "$1 required."; exit 1; fi

MacOS=false
Linux=false

case $(uname) in
  Darwin* ) MacOS=true ;;
  Linux*  ) Linux=true ;;
  * ) err_m "$(uname -a) not supported."; exit 1;;
esac

hash -r

# install homebrew
if ! exists "brew"; then
  info_m "\npreparing before installing homebrew..."
  if "${MacOS}"; then
    if ! exists "xcode-select"; then
      info_m "installing xcode-select..."
      xcode-select --install
    fi
  fi
  info_m "installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  "${Linux}" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

other_m "\nOK, now you can leave the computer!\n"
sleep 5

info_m "🍺  installing formulae with homebrew..."
while read formula; do
  [ -z "${formula}" ] && continue
  exists "${formula}" && continue
  case ${formula} in
    fzf  ) $(brew --prefix)/opt/fzf/install --no-key-bindings --completion --no-update-rc;;
    aws  ) brew install awscli;;
    *    ) brew install ${formula};;
  esac
done <<EOS
git
rg
fzf
exa
bat
tmux
nvim
nodenv
yarn
rbenv
php
pyenv
pyenv-virtualenv
ghq
hub
aws
$("${MacOS}" && echo "gnu-sed")
$("${MacOS}" && echo "deno")
$("${Linux}" && echo "zsh")
EOS
ok_m "\n🍺  brew install completed."

info_m "\ninstalling languages..."
info_m "Node.js:"
eval "$(nodenv init -)"
nodenv install 12.18.0
nodenv global 12.18.0

info_m "Ruby:"
eval "$(rbenv init -)"
rb_latest=$(rbenv install --list-all | grep '^[0-9.]\+$' | tail -1)
rbenv install ${rb_latest}
rbenv global ${rb_latest}

info_m "Python2:"
eval "$(pyenv init -)"
pyenv install 2.7.15
pyenv virtualenv 2.7.15 neovim-python2
pyenv activate neovim-python2
pip2 install neovim
pyenv deactivate

info_m "Python3:"
py_latest=$(pyenv install -l | grep '^  [0-9.]\+$' | tail -1)
pyenv install ${py_latest}
pyenv virtualenv ${py_latest} neovim-python3
pyenv activate neovim-python3
pip install neovim
pyenv deactivate
pyenv global ${py_latest}

if [ ! -d ~/.tmux/plugins/tpm ]; then
  info_m "installing tpm and tmux plugins..."
  git clone https://github.com/arks22/tmuximum.git ~/.tmux/plugins/tpm
  bash ~/.tmux/plugins/tpm/bin/install_plugins
fi

while read path; do
  ln -s "${path}" ~
done <<EOS
$(dirname $0)/.zshenv
$(dirname $0)/.config
EOS
