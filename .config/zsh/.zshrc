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

alias ls='ls --color'
alias ll='ls -lahF'
alias tmux='direnv exec / tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'
alias d='direnv edit .'
# https://apple.stackexchange.com/questions/31872/how-do-i-reset-the-scrollback-in-the-terminal-via-a-shell-command
alias clear="clear && printf '\e[3J'"
alias bios="sudo systemctl reboot --firmware-setup"

# https://mollifier.hatenablog.com/entry/20090728/p1
zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ${#line} -ge 5 ]] &&
    [[ ! "$line" =~ "^(cd|ls|ll|rm|mkdir|tms|mk)( |$)" ]]
}

typeset -A r_aliases
r_aliases=(
  "v"    "nvim"
  "gg"   "ghq get --shallow --update"
  "tmkt" "tmux kill-session -t"
)

typeset -A g_aliases
g_aliases=(
  # directory
  "..."      "../.."
  "...."     "../../.."
  "....."    "../../../.."
  "......"   "../../../../.."
  # pipe
  "G"        "| grep"
  "R"        "| rg"
  "X"        "| xargs"
  "L"        "| less"
  "A"        "| awk"
  "S"        "| sed"
  "E"        "2>&1 > /dev/null"
  "N"        "> /dev/null"
)

for abbr in ${(k)r_aliases}; do alias $abbr="${r_aliases[$abbr]}"; done
for abbr in ${(k)g_aliases}; do alias -g $abbr="${g_aliases[$abbr]}"; done

abbrev-expand() {
  local abbr
  [[ $LBUFFER =~ "[^ ]  *[^ ]" ]] && first=false || first=true
  abbr=$(echo ${LBUFFER} | grep -o '[-_a-zA-Z0-9\.]*$')
  if "${first}" && [ -n "${r_aliases[$abbr]}" ]; then
    zle backward-kill-word
    LBUFFER+=${r_aliases[$abbr]}
  elif [[ $LBUFFER =~ " *go +[a-z]+ +\./\.\.\." ]]; then
    # do nothing
  elif [ -n "${g_aliases[$abbr]}" ]; then
    zle backward-kill-word
    LBUFFER+=${g_aliases[$abbr]}
  fi
}

spacekey() { abbrev-expand; zle self-insert; }
zle -N spacekey
bindkey " " spacekey

enterkey() { abbrev-expand; zle accept-line; }
zle -N enterkey
bindkey "^m" enterkey

no-expand-space() { LBUFFER+=' '; }
zle -N no-expand-space
bindkey "^x " no-expand-space
bindkey "^x^m" accept-line


### suffix alias
# ref: https://itchyny.hatenablog.com/entry/20130227/1361933011
function kaito() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    # *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    # *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,bz2,tbz,Z,tar,xz}=kaito

typeset -agU precmd_functions;
typeset -agU chpwd_functions;

# direnv hook zsh の出力を改変したもの
_direnv_hook() {
  (( $+commands[direnv] )) || return
  trap -- '' SIGINT;eval "$(direnv export zsh)";trap - SIGINT;
}
chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )

required() {
  for arg; do
    if ! (( $+commands[$arg] )); then
      >&2 printf "${arg} required.\n"
      return 127
    fi
  done
}

__ghq_fzf() {
  # local preview_cmd
  # if (( $+commands[glow] )); then
  #   preview_cmd="glow --style=light $(ghq root)/{}/README.*"
  # elif (( $+commands[bat] )); then
  #   preview_cmd="bat -n --color=always --line-range :80 $(ghq root)/{}/README.*"
  # else
  #   preview_cmd="cat $(ghq root)/{}/README.* | head -n 80"
  # fi
  ghq list | fzf-tmux -p50%,70% --preview "${preview_cmd}" --no-multi
}

ghq_fzf() {
  required ghq fzf || return 127
  local repo=$(__ghq_fzf)
  if [ -n "${repo}" ]; then
    BUFFER="cd $(ghq root | sed -e "s@${HOME}@~@")/${repo}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq_fzf
bindkey -e '^g' ghq_fzf
bindkey -s '^[a' '^Qtms^M'

# fzf のキーバインドは CTRL-R のみ取り出して使用
# Paste the selected command from history into the command line
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle -N fzf-history-widget
bindkey -e '^R' fzf-history-widget

path=("$STARSHIP_BIN_DIR"(N-/) "$path[@]")
eval "$(starship init zsh)"

source "$ZINIT_HOME/zinit.zsh"
zinit wait lucid light-mode as'null' nocd \
    atinit'source "$ZDOTDIR/lazy.zsh"' \
    for 'zdharma-continuum/null'

if (which zprof > /dev/null 2>&1) then
  zprof | less
fi
