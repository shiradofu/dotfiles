export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export EDITOR="nvim"
export PAGER="less"
export LESS="-g -i -M -R -S -W"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export PATH="$PATH:$HOME/bin"

test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)
test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$GOPATH/bin"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
export WATCHMAN_CONFIG_FILE="$XDG_CONFIG_HOME/watchman/config.json"

skip_global_compinit=1
