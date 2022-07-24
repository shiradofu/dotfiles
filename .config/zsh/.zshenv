export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export EDITOR="nvim"
export PAGER="less"
export LESS="-g -i -M -R -S -W"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

export GOPATH="$XDG_STATE_HOME/go"
export ZINIT_HOME="$XDG_STATE_HOME/zinit/zinit.git"
export ASDF_DIR="$XDG_STATE_HOME/asdf/repo"
export ASDF_DATA_DIR="$XDG_STATE_HOME/asdf/data"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettier/.prettierrc.yml"

skip_global_compinit=1
