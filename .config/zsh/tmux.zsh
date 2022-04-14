alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

tms() {
  local cmd prompt selected
  required tmux fzf || return
  [ -n "$TMUX" ] && cmd=(fzf --border=none --margin=0,1) || cmd=(fzf)
  [ -n "$TMUX" ] \
    && prompt="current: $(tmux display-message -p '#S') > " \
    || prompt='> '

  selected=$({
    tmux ls -F '#{session_name}' -f '#{?session_attached,0,1}'
    echo '[new]'
  } | $cmd[@] --prompt=$prompt)

  case "${selected}" in
    '' ) return ;;
    '[new]' )
      local name
      while [ -z "${name}" ] || tmux ls 2>/dev/null | grep -q "${name}"; do
        zle -I
        printf 'new session name: '
        read name < /dev/tty
        [ -z "${name}" ] && printf "name required.\n\n" && continue
        name=$(echo "${name}" | sed 's/[.:]/_/g') # session_name で使えない文字を変換
        tmux ls 2>/dev/null | grep -q "${name}" && printf "${name} already exists.\n\n"
      done
      tmux new -d -s "${name}"
      selected=${name}
      ;;
  esac
  [ -n "$TMUX" ] \
    && tmux switch-client -t "${selected}" \
    || { BUFFER="tmux a -t '${selected}'" && zle accept-line && zle reset-prompt; }
}
zle -N tms
bindkey "^[a" tms
