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
  pager = delta
  # pager = less -R -F -X
[delta]
  navigate = true # use n and N to move between diff sections
  light = false   # set to true if you're in a terminal w/ a light background color
[interactive]
  diffFilter = delta --color-only
[add.interactive]
  useBuiltin = false # required for git 2.37.0
[merge]
  conflictstyle = diff3
[diff]
  colorMoved = default
