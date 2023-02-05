#!/bin/bash

password=$1
script_dir=$(cd "$(dirname "$0")" && pwd)

ln -s "$script_dir/wslsync" "$HOME/bin/"
ln -s "$script_dir/_wslsync" "$ZDOTDIR/completions/"

echo "$password" | wslsync -S --to-windows wsl_conf >/dev/null 2>&1
wslsync --to-windows wezterm
wslsync --to-windows wslconfig

curl -sLo /tmp/win32yank.zip \
  https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
mv /tmp/win32yank.exe ./bin

git config --file "${XDG_CONFIG_HOME}/git/credentials.gitconfig" \
  credential.helper \
  "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

unset password
