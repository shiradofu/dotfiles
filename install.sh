#!/bin/sh

NC="\033[0m"
ok_m()    { printf "\033[1;32m%$2s${NC}\n" "$1"; }                # green
err_m()   { printf "\033[1;31m%$2s${NC}\n" "$1" 1>&2; return 1; } # red
info_m()  { printf "\033[1;34m%$2s${NC}\n" "$1"; }                # blue
other_m() { printf "\033[1;35m%$2s${NC}\n" "$1"; }                # purple
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
  printf "\n"
  info_m "preparing before installing homebrew..."
  if "${MacOS}"; then
    if ! exists "xcode-select"; then
      info_m "installing xcode-select..."
      xcode-select --install
    fi
  fi
  info_m "installing homebrew..."
  "${Linux}" && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  "${Linux}" && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

printf "\n"
other_m "OK, now you can leave the computer!"
printf "\n"
sleep 5

info_m "🍺  installing formulae with homebrew..."

# gpg -> GnuPG: asdf-nodejs dependency
while read formula; do
  [ -z "${formula}" ] && continue
  exists "${formula}" && continue
  printf "\n"
  info_m "== brew install ${formula} =============================================================" .80
  case ${formula} in
    fzf  ) brew install fzf && $(brew --prefix)/opt/fzf/install --no-key-bindings --completion --no-update-rc;;
    aws  ) brew install awscli;;
    *    ) brew install ${formula};;
  esac
  ok_m "== ${formula} has been installed. ========================================================" .80
done <<EOS
git
rg
fzf
exa
bat
tmux
vim
nvim
ghq
hub
aws
gpg
asdf
yarn
direnv
$("${MacOS}" && echo "gnu-sed")
$("${Linux}" && echo "zsh")
EOS
printf "\n"
ok_m "🍺  brew install completed!"

printf "\n"
info_m "installing languages..."
info_m "Node.js:"
eval "$(nodenv init -)"
nodenv install 12.18.0
nodenv global 12.18.0

info_m "Ruby:"
eval "$(rbenv init -)"
rb_latest=$(rbenv install --list-all | grep '^[0-9.]\+$' | tail -1)
rbenv install ${rb_latest}
rbenv global ${rb_latest}

info_m "Python3:"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
py_latest=$(pyenv install -l | grep '^  [0-9.]\+$' | tail -1)
pyenv install ${py_latest}
pyenv virtualenv ${py_latest} neovim-python3
pyenv activate neovim-python3
pip3 install neovim
pyenv deactivate
pyenv global ${py_latest}

if [ ! -d ~/.tmux/plugins/tpm ]; then
  info_m "installing tpm and tmux plugins..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

while read path; do
  ln -s "${path}" ~
done <<EOS
$(dirname $0)/.zshenv
$(dirname $0)/.config
EOS

cat << 'EOF' > ~/post-install
[ -d /home/linuxbrew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
eval "$(command nodenv init -)"
eval "$(command rbenv init -)"
eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"
EOF

printf "\n"
ok_m "🎉  All installation are completed! 🎉"
printf "\n"
info_m " Please run following commnad."
printf "\n"
other_m "   source ~/post-install && rm ~/post-install"
printf "\n"
exit 0
