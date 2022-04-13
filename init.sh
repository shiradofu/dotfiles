#!/bin/sh

set -eu

msg() { printf "\033[1;34m$1\033[0m\n"; }
err() { printf "\033[1;31m$1\033[0m\n" 1>&2; return 1; }
exists() { type $1 > /dev/null 2>&1; }

hash -r
if ! exists sudo; then
  err "Please install 'sudo' command."
  exit 127
fi

DIST=''
for dist in debian redhat fedora; do
  if [ -e "/etc/${dist}-release" ] || [ -e "/etc/${dist}_version" ]; then
    DIST="${dist}"
    break
  fi
done

if [ -z "${DIST}" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    DIST=darwin
  else
    err "Sorry, your operating system is not supported."
    exit 1
  fi
fi

trap 'stty echo' INT PIPE TERM EXIT
[ -t 1 ] && exec < /dev/tty
msg "Please input password"
stty -echo
read password
stty echo
sudo -K
echo "${password}" | sudo -lS >/dev/null 2>&1 || exit 1

case "${DIST}" in
  debian )
    msg "installing basic packages..."
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
    echo "${password}" | sudo -S apt -y update
    echo "${password}" | sudo -S apt -y install rsync

    # required by homebrew
    echo "${password}" | sudo -S apt -y install build-essential procps curl file git bash

    # required by asdf python
    # echo "${password}" | sudo -S apt -y install make build-essential libssl-dev zlib1g-dev \
    #   libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    #   libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ;;
  redhat | fedora )
    msg "installing basic packages..."
    echo "${password}" | sudo -S yum -y update
    echo "${password}" | sudo -S yum -y install rsync

    # required by homebrew
    echo "${password}" | sudo -S yum -y groupinstall 'Development Tools'
    echo "${password}" | sudo -S yum -y install procps-ng curl file git bash

    # required by asdf python
    # echo "${password}" | sudo -S yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel \
    #   sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    ;;
  darwin )
    if ! exists "xcode-select"; then
        msg "installing xcode-select..."
        xcode-select --install
    fi
    ;;
esac

if ! exists "brew"; then
  url='https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
  curl -fsSL $url > _homebrew.sh
  msg "installing homebrew..."
  NONINTERACTIVE=1 bash _homebrew.sh

  rm _homebrew.sh

  test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)
  test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  echo "$password" | sudo -S chown -R $(whoami) $(brew --prefix)
fi

if [ "${DIST}" = "Darwin" ]; then
    msg "installing basic packages..."
    brew install binutils
    brew install coreutils
    brew install findutils
    brew install grep
    brew install gawk
    brew install gnu-sed
    brew install gnu-tar
    brew install gzip
    brew install wget
    brew install gpg

    # for asdf python
    brew install openssl readline sqlite3 xz zlib
fi

msg "\n🍺  installing ghq:\n"
brew install ghq

dotfiles=github.com/shiradofu/dotfiles
ghq get --shallow https://${dotfiles}
bash $(ghq root)/${dotfiles}/install.sh $password

unset password

# if [ -f "$0" ]; then rm "$0"; fi
