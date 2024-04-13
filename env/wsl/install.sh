#!/bin/bash

msg() { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
brew_i() { for X; do msg $'\n🍺  Installing '"$X"$':\n'; brew install "$X"; done }

password=$1
WSL_ROOT=$(cd "$(dirname "$0")" && pwd)

ln -s "$WSL_ROOT/wslsync" "$HOME/bin/"
ln -s "$WSL_ROOT/_wslsync" "$ZDOTDIR/completions/"
ln -s "$WSL_ROOT/ghrsync" "$HOME/bin/"
ln -s "$WSL_ROOT/_ghrsync" "$ZDOTDIR/completions/"

msg $'\n🔧  Copying wsl.conf: '
echo "$password" | wslsync -S --to-windows wsl_conf >/dev/null 2>&1 \
  && printf "ok\n" || printf "failed\n"
msg $'\n🔧  Copying .wslconfig: '
wslsync --to-windows wslconfig && printf "ok\n" || printf "failed\n"
# msg $'\n🔧  Copying resolv.conf: '
# echo "$password" | wslsync -S --to-windows resolv_conf && printf "ok\n" || printf "failed\n"
msg $'\n🔩  Copying wezterm config: '
wslsync --to-windows wezterm && printf "ok\n" || printf "failed\n"

msg $'\n🐳  Installing Docker Engine:'
curl -fsSL https://get.docker.com -o get-docker.sh && \
{ echo "$password" | sudo -S sh get-docker.sh; } && \
{ echo "$password" | sudo -S systemctl disable --now docker.service docker.socket; } && \
  dockerd-rootless-setuptool.sh install --skip-iptables && \
  sed -i 's/  --iptables=false//' "$XDG_CONFIG_HOME/systemd/user/docker.service" && \
  systemctl --user daemon-reload && \
  systemctl --user restart docker && \
  printf "ok\n" || printf "failed\n"
rm get-docker.sh
nsenter -U --preserve-credentials -n -m -t "$(cat "$XDG_RUNTIME_DIR/docker.pid")" \
  bash -c "
    printf '%s\n' 'nameserver 1.1.1.1' > /etc/resolv.conf
    printf '%s\n' 'nameserver 8.8.8.8' >> /etc/resolv.conf
  "

msg $'\n📎  Installing wslutil:'
# https://github.com/wslutilities/wslu/blob/2cc1c20ea5188ce93581eeddd3f73aa46c1b6c6e/extras/scripts/wslu-install
WSLU_BUILD_DIR=$(mktemp --tmpdir --directory wslu-install.XXXX)
if git clone --depth=1 --recursive --b v4.1.1 https://github.com/wslutilities/wslu "$WSLU_BUILD_DIR" \
  && cd "$WSLU_BUILD_DIR" \
  && make \
  && echo "$password" | sudo -S make install \
  && echo "$password" | sudo -S install -m755 extras/scripts/wslu-uninstall /usr/bin
then printf "ok\n"; else printf "failed\n"; fi

brew_i xsel

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credential.gitconfig" \
  credential.helper \
  "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe" \
  && printf "ok\n" || printf "failed\n"

unset password
