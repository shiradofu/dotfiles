#
# PATH 系設定
#
typeset -agU fpath
fpath=("$ZDOTDIR/completions" ${ASDF_DIR}/completions $fpath)
typeset -gaU manpath
manpath=("$HOMEBREW_PREFIX/share/man" $manpath)
typeset -gaU infopath
infopath=("$HOMEBREW_PREFIX/share/info" $infopath)

export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include"

if is_mac; then
  # export PATH="$HOMEBREW_PREFIX/opt/binutils/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnuman:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnuman:$MANPATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnuman:$MANPATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman:$MANPATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnuman:$MANPATH"
fi

if is_wsl; then
  # export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin"
  # export PATH="$PATH:/mnt/c/ProgramData/DockerDesktop/version-bin"
  export PATH="$PATH:/mnt/c/Windows/System32"
  export PATH="$PATH:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0"
fi

#
# ZSH のオプション設定
#
setopt noclobber             # リダイレクトでの上書き禁止
setopt no_beep               # ビープ音を消す
setopt correct               # コマンドtypo時の「もしかして:」
KEYTIMEOUT=1                 # Esc遅延解消
unsetopt prompt_cr           # 出力の最後にCRを付加しない
unsetopt prompt_sp           # 改行で終わらない出力を保護しない(crとセット)
setopt auto_cd               # パスのみでcd
WORDCHARS='*?_-.[]~&!#$%^(){}<>' # 単語の一部として扱う文字のセットから/=;を除外: Ctrl-w(単語削除)が止まる

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

# 履歴
setopt share_history        # 履歴をシェル間で共有
setopt extended_history     # 履歴にコマンド実行時刻/所要時間も記録
setopt hist_ignore_space    # spaceで始まる場合、コマンド履歴に追加しない
setopt hist_reduce_blanks   # 余分なスペースを削除してヒストリに記録する
setopt hist_no_store        # historyコマンドは履歴に登録しない
setopt append_history       # シェルのインスタンスごとに独立した履歴ファイルを生成しない
setopt hist_ignore_all_dups # 履歴追加時に重複があれば古いエントリを削除
# 7 文字以下かつ履歴に残すようなコマンドでない場合は記録しない
# https://mollifier.hatenablog.com/entry/20090728/p1
zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ${#line} -ge 7 ]] && [[ ! "$line" =~ "^(rm|mkdir|mk|tms)( |$)" ]]
}

#
# zinit
#
zinit wait lucid nocd for \
    zdharma-continuum/fast-syntax-highlighting \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" blockf nocd \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" nocd \
    zsh-users/zsh-autosuggestions

ZSH_AUTOSUGGEST_STRATEGY=completion
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(enterkey $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

zinit wait lucid is-snippet as"completion" nocd for \
  atload"autoload bashcompinit; bashcompinit; complete -C '$(which aws_completer)' aws" \
    https://github.com/aws/aws-cli/blob/v2/bin/aws_zsh_completer.sh

#
# hook
#
typeset -agU chpwd_functions;

# direnv hook zsh の出力を改変したもの
_direnv_hook() {
  (( $+commands[direnv] )) || return
  trap -- '' SIGINT;eval "$(direnv export zsh)";trap - SIGINT;
}
chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
_direnv_hook >/dev/null 2>&1

required() {
  for arg; do
    if ! (( $+commands[$arg] )); then
      >&2 printf "${arg} required.\n"
      return 127
    fi
  done
}

#
# 各種ツール・ウィジェットの設定
#
source "${ASDF_DIR}/lib/asdf.sh"
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p50%,70%'
export FZF_DEFAULT_OPTS="--height 50% --reverse --border=sharp --multi \
  --bind=ctrl-l:toggle-preview \
  --bind=ctrl-d:delete-char \
  --bind=ctrl-j:preview-down \
  --bind=ctrl-k:preview-up \
  --preview-window sharp"
(( $+commands[fd] )) && \
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore"
[ -f "${XDG_CONFIG_HOME}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME}"/fzf/fzf.zsh
export FZF_COMPLETION_TRIGGER=';'
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS --info=inline"

# fzf補完機能の対象となるコマンドを見つけるための関数
# 2番目以降のコマンドでもできるだけ使用できるように調整
# case-inのワンライナーとコマンド後の文字列内に区切り文字を含む場合は動作しない
__fzf_extract_command() {
  local token tokens _token
  _token=$(echo "$1" | sed -e 's/^.*[&|;<>]\s*\(.\{1,\}\)/\1/')
  tokens=(${(z)_token})
  for token in $tokens; do
    token=${(Q)token}
    if [[ "$token" =~ [[:alnum:]] && ! "$token" =~ "=" ]]; then
      echo "$token"
      return
    fi
  done
  echo "${tokens[1]}"
}

if (( $+commands[fd] )); then
  _fzf_compgen_path() { fd --hidden --follow . "$1"; }
  _fzf_compgen_dir() { fd --type d --hidden --follow -E '.git/*' . "$1"; }
  _fzf_complete_mk() {
    local l_save
    zle backward-delete-char
    l_save="$LBUFFER"
    _fzf_complete -- "$@" < <( fd --type d --hidden -E ".git/*" . )
    if [ "$?" = 0 ] && [ "$l_save" != "$LBUFFER" ]; then
      zle backward-delete-char
      LBUFFER+=/
    fi
  }
fi

_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

bindkey -s '^[a' '^Qtms^M'

ghq-fzf() {
  required ghq fzf || return 127
  local repo=$(ghq list | fzf-tmux ${FZF_TMUX_OPTS} --no-multi)
  if [ -n "${repo}" ]; then
    BUFFER="cd $(ghq root | sed -e "s@${HOME}@~@")/${repo}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey -e '^g' ghq-fzf

ghq-rm() {
  required ghq fzf || return 127
  local repos=$(ghq list | fzf-tmux ${FZF_TMUX_OPTS})
  [ -n "$repos" ] && echo "$repos" | xargs -I{} rm -rf $(ghq root)/{}
}

navi_dir="$XDG_CONFIG_HOME/navi"
export NAVI_CONFIG="$navi_dir/config.yml"
export NAVI_PATH="$navi_dir/main.cheat"
if is_pure_linux; then
  NAVI_PATH="$NAVI_PATH:$navi_dir/linux.cheat"
fi
alias navi="navi --path '$NAVI_PATH'"
navi-widget() {
  local cmd
  local pipe; pipe="${XDG_CACHE_HOME:-~/.cache}/navi_cmd"
  if [ -n "$TMUX" ]; then
    required navi fzf || return 127
    rm -f "$pipe"
    mkfifo "$pipe"
    (tmux popup -E -w 80% -h 70% \
      "NAVI_CONFIG=$NAVI_CONFIG navi --path '$NAVI_PATH' --print --fzf-overrides '--height 100%' > $pipe" &)
    cmd=$(cat "$pipe")
    rm -f "$pipe"
  else
    cmd=$(navi --print)
  fi
  if [ -z "$cmd" ]; then return; fi
  BUFFER="$cmd"
  zle accept-line
  zle reset-prompt
}
zle -N navi-widget
bindkey -e '^t' navi-widget

# fzf のキーバインドは CTRL-R のみ取り出して使用
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf-tmux ${FZF_TMUX_OPTS} --) )
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

# https://www.m3tech.blog/entry/dotfiles-bonsai#Zsh%E5%B0%8F%E3%83%8D%E3%82%BF%E7%B7%A8
docker() {
  if [ "$1" = "compose" ] || ! command -v "docker-$1" >/dev/null; then
    command docker "${@:1}" # 通常通りdockerコマンドを呼び出す
  else
    "docker-$1" "${@:2}" # docker-foo というコマンドが存在するときはそちらを起動する
  fi
}
# docker rm (上書き)
# 引数なしで呼び出したときはプロセスを fzf で選択して削除する
docker-rm() {
  if [ "$#" -eq 0 ]; then
    command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
  else
    command docker rm "$@"
  fi
}
# docker rmi (上書き)
# 引数なしで呼び出したときはイメージを fzf で選択して削除する
docker-rmi() {
  if [ "$#" -eq 0 ]; then
    command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
  else
    command docker rmi "$@"
  fi
}

export GHQ_ROOT=$(ghq root)
export NVIM_PLUG="$XDG_DATA_HOME/nvim/site/pack/packer/"
export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettier/rc.yml"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export GNUPGHOME="$XDG_STATE_HOME/gnupg"
