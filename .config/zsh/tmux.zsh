alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

tmux_safe_session_name() {
  echo $1 | sed 's/[.:]/_/g'
}

tms() {
  local cmd prompt selected
  required tmux fzf || return
  [ -n "$1" ] && cmd=(fzf --height $1) || cmd=(fzf)
  [ "$TERM_PROGRAM" = 'tmux' ] \
    && prompt="current: $(tmux display-message -p '#S') > " \
    || prompt='> '

  selected=$({
    tmux ls 2>/dev/null | grep -v '(attached)' | awk '{sub(/:$/, "", $1);print $1}' | \
    while read line; do printf "${line}\n"; done
    printf "[new]\n"
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
        name=$(tmux_safe_session_name "$name")
        tmux ls 2>/dev/null | grep -q "${name}" && printf "${name} already exists.\n\n"
      done
      tmux new -d -s "$name"
      selected=$name
      ;;
  esac
  [ "$TERM_PROGRAM" = 'tmux' ] \
    && tmux switch-client -t "$selected" \
    || { BUFFER="tmux a -t '$selected'" && zle accept-line && zle reset-prompt; }
}
zle -N tms
bindkey "^[a" tms

# tms_ghq() {
#   local repo name
#   required tmux fzf ghq || return
#   repo=$(_ghq_fzf)
#   if [ -z "$repo" ]; then
#     zle reset-prompt
#     return
#   fi
#   name=$(tmux_safe_session_name $(echo $repo | sed 's@^github.com/@@'))
#   [ tmux ls 2>/dev/null | grep -q "$name" ] ||
#     tmux new -d -s "$name" -c $(ghq root)/$repo
#   [ "$TERM_PROGRAM" = 'tmux' ] \
#     && tmux switch-client -t "$name" \
#     || { BUFFER="tmux a -t '$name'" && zle accept-line && zle reset-prompt; }
# }
# zle -N tms_ghq
# bindkey "^[g" tms_ghq
