# zmodload zsh/zprof && zprof
# 対話シェルでなければ.zshrcを読み込まない
case $- in *i*) ;; *) return;; esac

# lazy に置くと abbrev の展開に失敗する
bindkey -e                   # emacsキーバインド
bindkey '^[[3~' delete-char  # deleteキー有効化
bindkey -e '^d' delete-char  # ^dで補完候補を出さない

# lazy に置くと履歴検索が壊れる
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000

# lazy に置いてもよいが alias 系をまとめておきたいのでこちらに
alias ls='ls --color'
alias ll='ls -lahF'
alias tmux='direnv exec / tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'
alias d='direnv edit .'
# https://apple.stackexchange.com/questions/31872/how-do-i-reset-the-scrollback-in-the-terminal-via-a-shell-command
alias clear="clear && printf '\e[3J'"
if is_wsl; then
  alias open=wslview
  winget() { cmd.exe /c "gsudo winget $*"; }
fi

# lazy に置くと展開に失敗する
typeset -A r_aliases
r_aliases=(
  "v"    "nvim"
  "gg"   "ghq get --shallow --update"
  "tmkt" "tmux kill-session -t"
)

typeset -A g_aliases
g_aliases=(
  # directory
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
  "P"        "$XDG_DATA_HOME/nvim/site/pack/packer"
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

# suffix alias
# ref: https://itchyny.hatenablog.com/entry/20130227/1361933011
# lazy に置いてもよいが alias 系をまとめておきたいのでこちらに
function kaito() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,bz2,tbz,Z,tar,xz}=kaito

# lazy 読み込み
export ZINIT_HOME="$XDG_STATE_HOME/zinit/zinit.git"
source "$ZINIT_HOME/zinit.zsh"
zinit wait lucid light-mode as'null' nocd \
    atinit'source "$ZDOTDIR/lazy.zsh"' \
    for 'zdharma-continuum/null'

# lazy に置くと初回表示時にエラーが発生する
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

if (which zprof > /dev/null 2>&1) then
  zprof | less
fi
