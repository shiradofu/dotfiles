#!/bin/bash

if ! exists "brew"; then
  if is_mac && ! exists "xcode-select"; then
      msg "installing xcode-select..."
      xcode-select --install
  fi
  url='https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
  curl -fsSL $url > _homebrew.sh
  msg "installing homebrew..."

  expect -c "
    spawn bash _homebrew.sh
    for { set i 0 } { \$i <= 1 } { incr i } {
      expect {
        \" password for\" { send -- \"$1\r\" }
        \"Password:\" { send -- \"$1\r\" }
        \"Press RETURN\" { send \"\r\" }
      }
    }
    interact
  "

  rm _homebrew.sh

  test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)
  test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

echo "$1" | sudo -S chown -R $(whoami) $(brew --prefix)

msg "🍺  installing formulae with homebrew..."

brew install zsh
brew install fzf
brew install rg
brew install fd
brew install jq
brew install bat
brew install git-delta
brew install tmux
brew install nvim
brew install starship
brew install asdf
brew install php
brew install composer
brew install yarn
brew install awscli
brew install git
brew install gh
brew install ghq
brew install gitui
brew install tokei
brew install act
brew install bitwarden-cli
brew install watchman # for coc-tsserver

if is_mac; then
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

[ ! -d "$ZDOTDIR/completions" ] && mkdir -p $ZDOTDIR/completions
gh completion -s zsh > $ZDOTDIR/completions/_gh

$(brew --prefix)/opt/fzf/install --completion --no-key-bindings --no-update-rc --xdg

echo "$1" | sudo -S sh -c "printf '${HOMEBREW_PREFIX}/bin/zsh\n' >> /etc/shells"

msg "\n🍺  brew install completed!"
