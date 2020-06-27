#!/bin/sh

NC="\033[0m"
err_m()   { printf "\033[1;31m%$2s${NC}\n" "$1" 1>&2; return 1; } # red
info_m()  { printf "\033[1;34m%$2s${NC}\n" "$1"; }                # blue

if ! type sudo > /dev/null 2>&1; then
  err_m "Please install 'sudo' command first."
  exit 1
fi

if [ -d ~/dotfiles ]; then
  err_m "'~/dotfiles' already exists."
  exit 1
fi

while read dist; do
  if [ -e "/etc/${dist}-release" ] || [ -e "/etc/${dist}_version" ]; then
    DIST="${dist}"
    break
  fi
done <<EOL
debian
redhat
fedora
EOL

if [ -z "${DIST}" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    DIST=MacOS
  else
    err_m "Sorry, your OS is not supported."
    exit 1
  fi
fi

[ -t 1 ] && exec < /dev/tty
info_m "Please input password"
stty -echo
read password
stty echo
sudo -K
echo "${password}" | sudo -S echo -n "" >/dev/null 2>&1 || err_m "password is wrong" || exit 1

info_m "installing basic packages..."
# zlib1g-dev: for languages installation
# libffi-dev: for python
case "${DIST}" in
  debian )
    echo "${password}" | sudo -S apt update -y
    echo "${password}" | sudo -S apt install build-essential -y
    echo "${password}" | sudo -S apt install curl file git bash zlib1g-dev libffi-dev locales -y
    ;;
  redhat | fedora )
    echo "${password}" | sudo -S yum update -y
    echo "${password}" | sudo -S yum groupinstall 'Development Tools' -y
    echo "${password}" | sudo -S yum install curl file git bash zlib1g-dev libffi-dev locales -y
    echo "${password}" | sudo -S yum install libxcrypt-compat -y
    ;;
  MacOS ) ;;
  * ) err_m "Oops, something went wrong."; exit 1;;
esac

cd && git clone https://github.com/shiradofu/dotfiles.git
sh ~/dotfiles/install.sh
