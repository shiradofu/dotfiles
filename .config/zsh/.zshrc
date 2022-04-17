# zmodload zsh/zprof && zprof

# 対話シェルでなければ.zshrcを読み込まない
case $- in *i*) ;; *) return;; esac

# 全般
bindkey -e                   # emacsキーバインド
bindkey '^[[3~' delete-char  # deleteキー有効化
bindkey -e '^d' delete-char  # ^dで補完候補を出さない
setopt noclobber             # リダイレクトでの上書き禁止
setopt no_beep               # ビープ音を消す
setopt correct               # コマンドtypo時の「もしかして:」
KEYTIMEOUT=1                 # Esc遅延解消
unsetopt prompt_cr           # 出力の最後にCRを付加しない
unsetopt prompt_sp           # 改行で終わらない出力を保護しない(crとセット)
# setopt sh_word_split         # 変数を含むコマンド実行時にスペースで分割する

setopt auto_cd      # パスのみでcd
cdpath=(~ $(ghq root)/github.com)

# 単語の一部として扱う文字のセットから/=;を除外: Ctrl-w(単語削除)が止まる
WORDCHARS='*?_-.[]~&!#$%^(){}<>'

# 重複を削除
typeset -gU path PATH cdpath fpath manpath
fpath=("$ZDOTDIR/completions" $fpath)

# 補完
setopt auto_list # 補完が複数あるときは一覧表示する
setopt auto_menu # 補完を連続で要求するとメニュー表示
zstyle ':completion:*:default' menu select=2 # メニュー表示は少なくとも2候補あるときのみ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# case-insensitive https://qiita.com/watertight/items/2454f3e9e43ef647eb6b
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
zstyle ':completion:*' completer _complete _ignored _approximate
# cdpathの候補を表示しない
# https://superuser.com/questions/265547/zsh-cdpath-and-autocompletion
zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
    'local-directories named-directories'

zmodload zsh/complist # "bindkey -M menuselect"設定できるようにするためのモジュールロード
bindkey -M menuselect '^o' accept-and-infer-next-history # 次の補完メニューを表示する
bindkey -M menuselect '^r' history-incremental-search-forward # 補完候補内インクリメンタルサーチ

# 履歴
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups # ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmdを使用する際は無効化
setopt hist_ignore_space    # spaceで始まる場合、コマンド履歴に追加しない
setopt hist_reduce_blanks   # 余分なスペースを削除してヒストリに記録する

source $ZDOTDIR/zinit.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/utils.zsh
source $ZDOTDIR/wsl.zsh
source $ZDOTDIR/mac.zsh

unset ASDF_DIR # https://github.com/ohmyzsh/ohmyzsh/issues/10484
source $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh

eval "$(starship init zsh)"

if (which zprof > /dev/null 2>&1) then
  zprof | less
fi
