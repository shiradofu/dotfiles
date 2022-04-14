__ghq_fzf() {
  local preview_cmd
  required ghq fzf || return
  exists bat \
    && preview_cmd="bat -n --color=always --line-range :80 $(ghq root)/{}/README.*" \
    || preview_cmd="cat $(ghq root)/{}/README .* | head -n 80"
  ghq list | fzf-tmux -p90%,70% --preview "${preview_cmd}"
}

ghq_fzf() {
  local repo=$(__ghq_fzf)
  if [ -n "${repo}" ]; then
    BUFFER="cd $(ghq root | sed -e "s@${HOME}@~@")/${repo}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq_fzf
bindkey -e '^g' ghq_fzf
