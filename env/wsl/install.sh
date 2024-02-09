#!/bin/bash

msg() { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }

password=$1
WSL_ROOT=$(cd "$(dirname "$0")" && pwd)

ln -s "$WSL_ROOT/wslsync" "$HOME/bin/"
ln -s "$WSL_ROOT/_wslsync" "$ZDOTDIR/completions/"

msg $'\n🔧  Copying wsl.conf: '
echo "$password" | wslsync -S --to-windows wsl_conf >/dev/null 2>&1 \
  && printf "ok\n" || printf "failed\n"
msg $'\n🔧  Copying .wslconfig: '
wslsync --to-windows wslconfig && printf "ok\n" || printf "failed\n"
msg $'\n🔧  Copying resolv.conf: '
wslsync --to-windows resolv_conf && printf "ok\n" || printf "failed\n"
msg $'\n🔩  Copying wezterm config: '
wslsync --to-windows wezterm && printf "ok\n" || printf "failed\n"

msg $'\n🐳  Installing Docker Engine:'
curl -fsSL https://get.docker.com -o get-docker.sh && \
{ echo "$password" | sudo -S sh get-docker.sh; } && \
  dockerd-rootless-setuptool.sh install --skip-iptables && \
  sed -i 's/  --iptables=false//' "$XDG_CONFIG_HOME/systemd/user/docker.service" && \
  printf "ok\n" || printf "failed\n"
rm get-docker.sh

msg $'\n📎  Installing win32yank:'
curl -sLo /tmp/win32yank.zip \
  https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
mv /tmp/win32yank.exe "$HOME/bin/" && printf "ok\n" || printf "failed\n"

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credential.gitconfig" \
  credential.helper \
  "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe" \
  && printf "ok\n" || printf "failed\n"

unset password