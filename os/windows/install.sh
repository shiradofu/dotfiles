#!/bin/bash

msg() { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }

password=$1
script_dir=$(cd "$(dirname "$0")" && pwd)

ln -s "$script_dir/wslsync" "$HOME/bin/"
ln -s "$script_dir/_wslsync" "$ZDOTDIR/completions/"

msg $'\n🔧  Copying wsl.conf: '
echo "$password" | wslsync -S --to-windows wsl_conf >/dev/null 2>&1 \
  && printf "ok\n" || printf "failed\n"
msg $'\n🪛  Copying .wslconfig: '
wslsync --to-windows wslconfig && printf "ok\n" || printf "failed\n"
msg $'\n🔩  Copying wezterm config: '
wslsync --to-windows wezterm && printf "ok\n" || printf "failed\n"

msg $'\n📎  Installing win32yank:'
curl -sLo /tmp/win32yank.zip \
  https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
mv /tmp/win32yank.exe ./bin

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credential.gitconfig" \
  credential.helper \
  "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe" \
  && printf "ok\n" || printf "failed\n"

unset password
