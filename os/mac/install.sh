#!/bin/bash

MAC_ROOT=$(cd "$(dirname "$0")" && pwd)

brew install binutils coreutils findutils grep gawk gnu-sed gnu-tar gzip wget gpg
git config --global credential.helper osxkeychain

if [ ! -e "$HOME/.mackup" ]; then
  ln -s "$MAC_ROOT/.mackup" "$HOME/.mackup"
fi
if [ ! -e "$HOME/.mackup.cfg" ]; then
  ln -s "$MAC_ROOT/.mackup.cfg" "$HOME/.mackup.cfg"
fi
