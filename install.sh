#!/bin/sh

NC="\033[0m"
ok_m()    { printf "\033[0;32m$1\n${NC}"; }      # green
err_m()   { printf "\033[1;31m$1\n${NC}" 1>&2; } # red
info_m()  { printf "\033[0;34m$1\n${NC}"; }      # blue
other_m() { printf "\033[1;35m$1\n${NC}"; }      # purple
exists()  { type $1 > /dev/null 2>&1; }
required() if ! exists $1; then err_m "$1 required."; exit 1; fi
# pkg_initialized=false

case $(uname) in
  Darwin*     ) OS="Mac"  ;;
  *microsoft* ) OS="WSL"  ;;
  Linux*      ) OS="Linux";;
  * ) err_m "$(uname -a) not supported."; exit 1;;
esac

hash -r
required "bash"
required "sudo"

# install homebrew
if ! exists "brew"; then
  info_m "preparing before installing homebrew..."
  case ${OS} in
    Mac )
      if ! exists "xcode-select"; then
        info_m "installing xcode-select..."
        xcode-select --install
      fi
      ;;
    WSL | Linux )
      if exists "apt"; then
        sudo apt update
        sudo apt upgrade
        sudo apt install build-essential curl file git -y
      elif exists "yum"; then
        sudo yum update
        sudo yum groupinstall 'Development Tools' -y
        sudo yum install curl file git -y
        sudo yum install libxcrypt-compat -y
      fi
      ;;
  esac
  info_m "installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  if [ ${OS} = "WSL" -o ${OS} = "Linux" ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  fi
fi

other_m "\nOK, now you can leave the computer!\n"
sleep 5

info_m "installing formulae with homebrew..."
while read formula; do
  [ -z "${formula}" ] && continue
  exists "${formula}" && continue
  # [ "${formula}" = "rg" ] && brew install ripgrep; continue
  # [ "${formula}" = "nvim" ] && brew install neovim; continue
  # [ "${formula}" = "yarn" ] && brew install yarn --ignore-dependencies; continue
  echo ${formula}
done <<EOS
git
rg
fzf
tmux
nvim
nodenv
pyenv
pyenv-virtualenv
yarn
hub
$([ ${OS} = "Mac" ] && echo "gnu-sed")
$([ ${OS} = "WSL" ] && echo "zsh")
EOS
ok_m "brew install completed."
