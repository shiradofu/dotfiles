exists gh && test ! -f "${HOME}"/.zinit/completions/_gh \
  && gh completion -s zsh > "${HOME}"/.zinit/completions/_gh

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

git-wt() {
  local branch root wtdir
  case $1 in
    -d )
      [ -z "$2" ] && { echo 'branch name required.'; return 1 }
      branch=$2
      ;;
    * )
      [ -z "$1" ] && { echo 'branch name required.'; return 1 }
      branch=$1
      ;;
  esac
  root=$(git rev-parse --show-toplevel | sed -e 's@/\.wt-.*@@')
  wtdir=".wt-$(basename $root)-$(echo $branch | sed -e 's@/@-@g')/"
  cd $root || return 1
  case $1 in
  -d )
      printf "delete worktree for ${branch}? (y to continue): "
      local dw; read dw
      [ "$dw" != 'y' ] && { echo canceled.; return 1 }
    [ -d $wtdir ] && rm -rf $wtdir ||
      { echo "worktree for ${branch} does not exist."; return 1 }
    ;;
  * )
    [ -d $wtdir ] && { cd $wtdir; return }
    git fetch --all > /dev/null
    if ! git show-ref --quiet $branch; then # ブランチ存在確認
      printf "create branch and worktree '${branch}'? (y to continue): "
      local cb; read cb
      [ "$cb" != 'y' ] && { echo canceled.; return 1 }
      git branch $branch || return 1
    else
      printf "create worktree for ${branch}? (y to continue): "
      local cw; read cw
      [ "$cw" != 'y' ] && { echo canceled.; return 1 }
    fi
    \time rsync -av ./ $wtdir --exclude='.wt-*/' || return 1
    cd $wtdir || return 1
    git reset --hard HEAD
    git switch $branch
    ;;
  esac
}
