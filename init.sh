if ! type git > /dev/null 2>&1; then
  echo 'please install git first.'
  exit 1
fi

cd
git clone https://github.com/shiradofu/dotfiles.git
sh dotfiles/install.sh
