#!/bin/bash

script_dir=$(cd "$(dirname "$0")" && pwd)

brew install binutils coreutils findutils grep gawk gnu-sed gnu-tar gzip wget gpg
git config --file "${XDG_CONFIG_HOME}/git/credentials.gitconfig" credential.helper osxkeychain

if [ ! -e "$HOME/.mackup" ]; then
  ln -s "$script_dir/.mackup" "$HOME/.mackup"
fi
if [ ! -e "$HOME/.mackup.cfg" ]; then
  ln -s "$script_dir/.mackup.cfg" "$HOME/.mackup.cfg"
fi
