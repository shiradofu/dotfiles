[filter "lfs"]
  clean = git-lfs clean -- %f
  smudge = git-lfs smudge -- %f
  process = git-lfs filter-process
  required = true
[init]
  defaultBranch = main
[user]
  name =
  email =
[color]
  ui = true
[alias]
  aa = add -A
  cm = commit
  st = status
  co = checkout
  br = branch
  lg = log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'
[push]
  default = simple
[core]
  editor = nvim
  autocrlf = false
  ignorecase = false
  quotepath = false
  pager = less -R -F -X
[pager]
  diff = delta
  log = delta
  reflog = delta
  show = delta
[interactive]
  diffFilter = delta --color-only --features=interactive
[delta]
  features = decorations
[delta "interactive"]
  keep-plus-minus-markers = false
[delta "decorations"]
  commit-decoration-style = blue ol
  commit-style = raw
  file-style = omit
  hunk-header-decoration-style = blue box
  hunk-header-file-style = red
  hunk-header-line-number-style = "#067a00"
  hunk-header-style = file line-number syntax
