#!/bin/sh

NC="\033[0m"
ok_m()    { printf "\033[0;32m$1\n${NC}"; }      # green
err_m()   { printf "\033[1;31m$1\n${NC}" 1>&2; } # red
info_m()  { printf "\033[0;34m$1\n${NC}"; }      # blue
other_m() { printf "\033[1;35m$1\n${NC}"; }      # purple
exists()  { type $1 > /dev/null 2>&1; }
required() if ! exists $1; then err_m "$1 required."; exit 1; fi

MacOS=false
WSL=false
Linux=false

case $(uname) in
  Darwin*     ) MacOS=true ;;
  *microsoft* ) WSL=true   ;;
  Linux*      ) Linux=true ;;
  * ) err_m "$(uname -a) not supported."; exit 1;;
esac

hash -r

if "${Linux}" || "${WSL}"; then
  if exists "apt"; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install build-essential curl file git bash sudo -y
  elif exists "yum"; then
    sudo yum update -y
    sudo yum groupinstall 'Development Tools' -y
    sudo yum install curl file git bash sudo -y
    sudo yum install libxcrypt-compat -y
  fi
fi

# install homebrew
if ! exists "brew"; then
  info_m "preparing before installing homebrew..."
  if "${MacOS}"; then
    if ! exists "xcode-select"; then
      info_m "installing xcode-select..."
      xcode-select --install
    fi
  info_m "installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  "${WSL}" || "${Linux}" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi
fi

other_m "\nOK, now you can leave the computer!\n"
sleep 5

info_m "installing formulae with homebrew..."
while read formula; do
  [ -z "${formula}" ] && continue
  exists "${formula}" && continue
  case ${formula} in
    fzf  ) (brew --prefix)/opt/fzf/install --no-key-bindings --completion --no-update-rc
    yarn ) brew install yarn --ignore-dependencies;;
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
deno
nodenv
yarn
rbenv
phpbrew
pyenv
pyenv-virtualenv
ghq
hub
aws
$("${MacOS}" && echo "gnu-sed")
$("${Linux}" || "${WSL}" && echo "zsh")
EOS
ok_m "brew install completed."
