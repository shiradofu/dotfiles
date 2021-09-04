! exists fzf && ! exists fd && return
[ -f "${XDG_CONFIG_HOME}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME}"/fzf/fzf.zsh

export FZF_DEFAULT_OPTS="--height 40% --reverse --border=sharp --multi \
--bind=ctrl-o:toggle-preview \
--bind=ctrl-d:delete-char \
--bind=ctrl-j:preview-down \
--bind=ctrl-k:preview-up \
--preview-window sharp"
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p50%,70%'
export FZF_COMPLETION_TRIGGER=';'
export FZF_COMPLETION_OPTS="$FZF_DEFAULT_OPTS --info=inline"
FD_NO_IGNORE="--no-ignore --exclude='.wt-*'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden ${FD_NO_IGNORE}"

__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

# CTRL-R - Paste the selected command from history into the command line
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

_fzf_compgen_path() {
  fd --hidden --follow "${=FD_NO_IGNORE}" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow "${=FD_NO_IGNORE}" . "$1"
}

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

_fzf_complete_php() {
  zle backward-delete-char
  if [[ $LBUFFER =~ "php +artisan +test +" ]]; then
    _fzf_complete -- "$@" < <( fd '.*Test\.php' .); return
  else
    _fzf_complete -- "$@" < <( fd '.*\.php' .); return
  fi
}

_fzf_complete_git() {
  zle backward-delete-char
  if [[ $LBUFFER =~ "git +co +" ]]; then
    _fzf_complete -- "$@" < <( git branch -a | sed 's/^[*+]*\s*\(remotes\/\)*//' | cut -d ' ' -f1 ); return
  else
    _fzf_complete -- "$@" < <({ git ls-files; git ls-files --others --exclude-standard }); return
  fi
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
