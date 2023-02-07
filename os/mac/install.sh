#!/bin/bash

msg()    { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
brew_i() { for X; do msg $'\n🍺  Installing '"$X"$':\n'; brew install "$X"; done }

script_dir=$(cd "$(dirname "$0")" && pwd)

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credential.gitconfig" credential.helper osxkeychain

msg $'\n☁️  Deploying Mackup config:'
if [ ! -e "$HOME/.mackup" ]; then ln -s "$script_dir/.mackup" "$HOME/"; fi
if [ ! -e "$HOME/.mackup.cfg" ]; then ln -s "$script_dir/.mackup.cfg" "$HOME/"; fi
