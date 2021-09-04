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

# zlib1g-dev: for languages installation
case "${DIST}" in
  debian )
    msg "installing basic packages..."
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    echo "${password}" | sudo -S apt -y update

    # for homebrew
    echo "${password}" | sudo -S apt -y install build-essential procps curl file git bash

    # for asdf python
    echo "${password}" | sudo -S apt -y install make build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ;;
  redhat | fedora )
    msg "installing basic packages..."
    echo "${password}" | sudo -S yum -y update

    # for homebrew
    echo "${password}" | sudo -S yum -y groupinstall 'Development Tools'
    echo "${password}" | sudo -S yum -y install procps-ng curl file git bash

    # for asdf python
    echo "${password}" | sudo -S yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel \
      sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    ;;
  darwin ) ;;
esac

cd && git clone https://github.com/shiradofu/dotfiles.git
bash ./dotfiles/install/main.sh $password
unset password

if [ -f "$0" ]; then rm "$0"; fi
