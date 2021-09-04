export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LANG="ja_JP.UTF-8"
export EDITOR="nvim"
export PAGER="less"
export LESS="-g -i -M -R -S -W"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export PATH="$HOME/bin:$PATH"

test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)
test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

skip_global_compinit=1
