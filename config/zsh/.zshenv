setopt no_global_rcs > /dev/null 2>&1

is_mac() { [[ "$OSTYPE" == "darwin"* ]]; }
is_wsl() { [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; }
is_pure_linux() { ! is_mac && ! is_wsl; }

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$TMPDIR"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export EDITOR="nvim"
export PAGER="less"
export LESS="-g -i -M -R -S -W"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

if [ -d /opt/homebrew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew/Homebrew";
elif [ -f /usr/local/bin/brew  ]; then
  export HOMEBREW_PREFIX="/usr/local";
  export HOMEBREW_CELLAR="/usr/local/Cellar";
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
elif [ -d /home/linuxbrew ]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
fi

export COLIMA_HOME="$XDG_CONFIG_HOME/colima"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export LIMA_HOME="$XDG_CONFIG_HOME/lima"

export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/sbin:$PATH"
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$XDG_DATA_HOME/mise/shims:$PATH"
export PATH="$HOME/bin:$PATH"

export GHQ_ROOT="$HOME/ghq"
export MY_REPOS="$GHQ_ROOT/github.com/shiradofu"
export NVIM_PLUG="$XDG_DATA_HOME/nvim/lazy"

skip_global_compinit=1
