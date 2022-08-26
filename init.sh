#!/bin/sh

set -eu

msg() { printf "\033[1;34m%s\033[0m\n" "$1"; }
err() { printf "\033[1;31m%s\033[0m\n" "$1" 1>&2; return 1; }
exists() { type "$1" > /dev/null 2>&1; }

hash -r
if ! exists sudo; then
  err "Please install 'sudo' command."
  exit 127
fi

DIST=''
if [ "$(uname)" = "Darwin" ]; then
  DIST=mac
else
  for dist in debian redhat fedora; do
    if [ -e "/etc/${dist}-release" ] || [ -e "/etc/${dist}_version" ]; then
      DIST="${dist}"
      break
    fi
  done
fi
if [ -z "${DIST}" ]; then
  err "Sorry, your operating system is not supported."
  exit 1
fi

trap 'stty echo' INT PIPE TERM EXIT
[ -t 1 ] && exec < /dev/tty
msg "Please input password"
stty -echo
read -r password
stty echo
sudo -K
echo "${password}" | sudo -lS >/dev/null 2>&1 || exit 1
printf "Password successfully verified!\n"

while true; do
  msg "Please input git username"
  read -r git_name
  msg "Please input git email"
  read -r git_email

  printf "\nname:\t%s\nemail:\t%s\n\nOK?(y/n)" "$git_name" "$git_email"
  read -r yn
  case "$yn" in [Yy] ) break;; esac
done

clear
printf "\n ==========================================\n\n"
printf "   "
printf "\033[0;31mOK, "
printf "\033[1;33mnow "
printf "\033[1;32myou "
printf "\033[0;32mcan "
printf "\033[0;36mleave "
printf "\033[0;34mthe "
printf "\033[0;35mcomputer! "
printf "\033[0m☕"
printf "\n\n ==========================================\n"

sleep 3

case "${DIST}" in
  debian )
    msg "installing basic packages..."
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
    echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
    echo "${password}" | sudo -S apt -y update
    # required by homebrew
    echo "${password}" | sudo -S apt -y install build-essential procps curl file git bash
    # required by asdf-deno and bun
    echo "${password}" | sudo -S apt -y install unzip
    # required by asdf-python
    echo "${password}" | sudo -S apt -y install make build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ;;
  redhat | fedora )
    msg "installing basic packages..."
    echo "${password}" | sudo -S yum -y update
    # required by homebrew
    echo "${password}" | sudo -S yum -y groupinstall 'Development Tools'
    echo "${password}" | sudo -S yum -y install procps-ng curl file git bash
    # required by asdf-deno and bun
    echo "${password}" | sudo -S dnf -y install unzip
    # required by asdf-python
    echo "${password}" | sudo -S dnf -y install make gcc zlib-devel bzip2 bzip2-devel \
      readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    ;;
  mac )
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

  test -f /usr/local/bin/brew && eval "$(/usr/local/bin/brew shellenv)"
  test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  echo "$password" | sudo -S chown -R "$(whoami)" "$(brew --prefix)"
fi

if [ "$DIST" = 'mac' ]; then
  # required by asdf-deno and bun
  brew install unzip
  # required by asdf-python
  brew install openssl readline sqlite3 xz zlib
fi

msg "\n🍺  Installing git:\n"
brew install git

msg "\n🍺  Installing ghq:\n"
brew install ghq

msg "\n✨  Cloning dotfiles repository...\n"
repo=github.com/shiradofu/dotfiles
ghq get --update https://${repo}
repo_root="$(ghq root)/${repo}"
git -C "${repo_root}" config --local diff.ignoreSubmodules all
[ -n "$1" ] && git -C "${repo_root}" checkout "$1" # for debug

msg "\n🚀  Start installing!\n"
bash "${repo_root}/install.sh" "$password" "$git_name" "$git_email"

printf '\n  ====================================================================\n\n'
printf '  👏  \033[1;32mInstallation successfully completed! \033[0m\n\n'
cat << 'EOF'
  What to do next:

  - Run zsh to install plugin
  - Run `chsh -s $(brew --prefix)/bin/zsh` to set zsh to default shell
  - `aws configure` (access key is required)
  - `gh auth login`
EOF
printf '\n  ====================================================================\n\n'

unset password

# delete this script
if [ -f "$0" ]; then rm -f "$0"; fi
