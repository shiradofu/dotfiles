# zmodload zsh/zprof && zprof

# 対話シェルでなければ.zshrcを読み込まない
case $- in *i*) ;; *) return;; esac

# lazy に置くと履歴検索が壊れる
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000

# lazy 読み込み
export ZINIT_HOME="$XDG_STATE_HOME/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"
zinit wait lucid light-mode as'null' nocd \
    atinit'source "$ZDOTDIR/lazy.zsh"' \
    for 'zdharma-continuum/null'

# lazy に置くと初回表示時にエラーが発生する
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

if (which zprof > /dev/null 2>&1) then; zprof | less; fi
