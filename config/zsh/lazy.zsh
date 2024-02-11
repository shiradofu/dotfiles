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

export CGO_LDFLAGS="-O2 -g -L$HOMEBREW_PREFIX/lib"
export CGO_CFLAGS="-O2 -g -I$HOMEBREW_PREFIX/include"
export CGO_CXXFLAGS="-O2 -g -I$HOMEBREW_PREFIX/include"

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
  export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock" # for lazydocker
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

#
# 各種ツール・ウィジェットの設定
#
source "${ASDF_DIR}/asdf.sh"
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
# サブコマンドにも対応できるよう調整
__fzf_cmd_sub1=(docker ghq)
__fzf_extract_command() {
  local tokens ts t sub1
  tokens=$(echo "$1" | sed -e 's/^.*[&|;<>]\s*\(.\{1,\}\)/\1/')
  ts=(${(z)tokens})
  for ((i=0; i < ${#ts[@]}; i++)); do
    t=${(Q)ts[i]}
    if [[ "$t" =~ [[:alnum:]] && ! "$t" =~ "=" ]]; then
      sub1="${ts[i+1]}"
      if (($__fzf_cmd_sub1[(Ie)$t])) && [[ "$sub1" =~ [[:alnum:]] ]]; then
        echo "${t}-${sub1}"
      else
        echo "$t";
      fi
      return
    fi
  done
  echo "${ts[1]}"
}

if (( $+commands[fd] )); then
  _fzf_compgen_path() { fd --hidden --follow . "$1"; }
  _fzf_compgen_dir() { fd --type d --hidden --follow -E '.git/*' . "$1"; }
  _fzf_complete_mk() {
    zle backward-delete-char
    local l_save; l_save="$LBUFFER"
    _fzf_complete -- "$@" < <( fd --type d --hidden -E ".git/*" . ) \
      && [ "$l_save" != "$LBUFFER" ] && zle backward-delete-char
  }
fi

_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    docker-rm)    docker ps -a | fzf "$@" --header-lines=1 | awk '{ print $1 }';;
    docker-rmi)   docker images | fzf "$@" --header-lines=1 | awk '{ print $3 }';;
    ghq-rm)       ghq list | fzf --no-multi;;
    *)            fzf "$@" ;;
  esac
}

# fzf のキーバインドは CTRL-R のみ取り出して使用
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS=" $FZF_DEFAULT_OPTS $FZF_CTRL_R_OPTS
      -n2..,..
      --query=${(qqq)LBUFFER}
      --tiebreak=index
      --height ${FZF_TMUX_HEIGHT:-40%}
      --bind=ctrl-r:toggle-sort
      --no-multi
    " fzf-tmux ${FZF_TMUX_OPTS} --) )
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

bindkey -s '^[a' '^Qtms^M'

ghq-fzf() {
  { (( $+commands[ghq] )) && (($+commands[fzf])) } || return 127
  local repo=$(ghq list | fzf-tmux ${FZF_TMUX_OPTS} --no-multi)
  if [ -n "${repo}" ]; then
    BUFFER="cd $(ghq root | sed -e "s@${HOME}@~@")/${repo}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey -e '^g' ghq-fzf

navidir="$XDG_CONFIG_HOME/navi"
export NAVI_CONFIG="$navidir/config.yml"
export NAVI_PATH="$navidir/main.cheat\
$(is_mac && printf ":%s/mac.cheat" $navidir)\
$(is_wsl && printf ":%s/wsl.cheat" $navidir)\
$(is_pure_linux && printf ":%s/linux.cheat" $navidir)"

export GHQ_ROOT=$(ghq root)
export MY_REPOS="$GHQ_ROOT/github.com/shiradofu"
export NVIM_PLUG="$XDG_DATA_HOME/nvim/lazy"
