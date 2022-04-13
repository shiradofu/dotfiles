alias ls='ls --color'
alias ll='ls -lahF'

typeset -A r_aliases
r_aliases=(
  "v"    "nvim"
  "gg"   "ghq get --shallow --update "
  "tmkt" "tmux kill-session -t"
)

typeset -A g_aliases
g_aliases=(
  # directory
  "./..."    "./..."
  "..."      "../.."
  "...."     "../../.."
  "....."    "../../../.."
  "......"   "../../../../.."
  # pipe
  "G"        "| grep"
  "R"        "| rg"
  "X"        "| xargs"
  "L"        "| less"
  "A"        "| awk"
  "S"        "| sed"
  "E"        "2>&1 > /dev/null"
  "N"        "> /dev/null"
)

for abbr in ${(k)r_aliases}; do alias $abbr="${r_aliases[$abbr]}"; done
for abbr in ${(k)g_aliases}; do alias -g $abbr="${g_aliases[$abbr]}"; done

abbrev-expand() {
  local abbr
  [[ $LBUFFER =~ "[^ ]  *[^ ]" ]] && first=false || first=true
  abbr=$(echo ${LBUFFER} | grep -o '[-_a-zA-Z0-9\.]*$')
  if "${first}" && [ -n "${r_aliases[$abbr]}" ]; then
    zle backward-kill-word
    LBUFFER+=${r_aliases[$abbr]}
  elif [[ $LBUFFER =~ " *go +[a-z]+ +\./\.\.\." ]]; then
    # do nothing
  elif [ -n "${g_aliases[$abbr]}" ]; then
    zle backward-kill-word
    LBUFFER+=${g_aliases[$abbr]}
  fi
}

spacekey() { abbrev-expand; zle self-insert; }
zle -N spacekey
bindkey " " spacekey

enterkey() { abbrev-expand; zle accept-line; }
zle -N enterkey
bindkey "^m" enterkey

no-expand-space() { LBUFFER+=' '; }
zle -N no-expand-space
bindkey "^x " no-expand-space
bindkey "^x^m" accept-line


### suffix alias
# ref: https://itchyny.hatenablog.com/entry/20130227/1361933011
function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    # *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    # *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,bz2,tbz,Z,tar,xz}=extract
