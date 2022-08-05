{ test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv) } \
|| { test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv) }   \
|| { test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv) } \
|| { test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) }

typeset -gaU path
path=(
  "$HOME/bin"(N-/)
  "$GOPATH/bin"(N-/)
  "$ASDF_DIR/bin"(N-/)
  "$ASDF_DATA_DIR/shims"(N-/)
  "$path[@]"
)

. "${ASDF_DIR}/lib/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)

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

[ -f "${XDG_CONFIG_HOME}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME}"/fzf/fzf.zsh
export FZF_DEFAULT_OPTS="--height 50% --reverse --border=sharp --multi \
--bind=ctrl-l:toggle-preview \
--bind=ctrl-d:delete-char \
--bind=ctrl-j:preview-down \
--bind=ctrl-k:preview-up \
--preview-window sharp"
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p50%,70%'
export FZF_COMPLETION_TRIGGER=';'
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS --info=inline"

(( $+commands[fd] )) && \
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore"

__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

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
  _fzf_compgen_path() {
    fd --hidden --follow . "$1"
  }

  _fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
  }

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
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

# https://www.m3tech.blog/entry/dotfiles-bonsai#Zsh%E5%B0%8F%E3%83%8D%E3%82%BF%E7%B7%A8
docker() {
  if [ "$1" = "compose" ] || ! command -v "docker-$1" >/dev/null; then
    command docker "${@:1}" # 通常通りdockerコマンドを呼び出す
  else
    "docker-$1" "${@:2}" # docker-foo というコマンドが存在するときはそちらを起動する
  fi
}
# docker clean
# ExitedなDockerプロセスをすべて削除する
docker-clean() {
  command docker ps -aqf status=exited | xargs -r docker rm --
}
# docker cleani
# UntaggedなDockerイメージをすべて削除する
docker-cleani() {
  command docker images -qf dangling=true | xargs -r docker rmi --
}
# docker rm (上書き)
# 引数なしで docker rm したときはプロセスをFZFで選択して削除する
docker-rm() {
  if [ "$#" -eq 0 ]; then
    command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
  else
    command docker rm "$@"
  fi
}
# docker rmi (上書き)
# 引数なしで docker rmi したときはイメージをFZFで選択して削除する
docker-rmi() {
  if [ "$#" -eq 0 ]; then
    command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
  else
    command docker rmi "$@"
  fi
}

export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

if [[ "$OSTYPE" == "darwin"* ]]; then
  path=(
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/gawk/libexec/gnuman"(N-/)
    "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"(N-/)
    "$HOMEBREW_PREFIX/opt/llvm/bin"(N-/)
    "$path[@]"
  )

  typeset -gaU manpath
  manpath=(
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman"
    "$HOMEBREW_PREFIX/opt/findutils/libexec/gnuman"
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnuman"
    "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman"
    "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnuman"
    "$manpath[@]"
  )

  export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib"
  export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include"
fi

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  alias open=wslview

  path=(
    "$path[@]"
    "/mnt/c/Program Files/Docker/Docker/resources/bin"
    "/mnt/c/ProgramData/DockerDesktop/version-bin"
    "/mnt/c/Windows/System32"
  )
fi
