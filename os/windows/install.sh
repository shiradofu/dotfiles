#!/bin/bash

password=$1

echo "$password" | wslsync -S apply wsl_conf >/dev/null 2>&1
if exists wslvar && exists wslpath; then
  wslsync apply wezterm >/dev/null 2>&1
  wslsync apply wslconfig >/dev/null 2>&1
fi

curl -sLo /tmp/win32yank.zip \
  https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
mv /tmp/win32yank.exe ./bin

git config --global credential.helper \
  "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

unset password
