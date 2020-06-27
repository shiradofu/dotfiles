### STATS
#zmodload zsh/zprof && zprof

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

zmodload zsh/zpty

### GENERAL SETTINGS
bindkey -e
bindkey "^[[3~" delete-char
setopt extended_glob
setopt noclobber
setopt auto_cd
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt correct
typeset -U path PATH
# 単語の一部として扱う文字のセットから/を除外: Ctrl-w(単語削除)が/で止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
KEYTIMEOUT=1


### ALIAS SETTINGS
source $ZDOTDIR/.zalias


### PROMPT SETTINGS
source $ZDOTDIR/.zprompt


### CLI TOOLS SETTINGS
source $ZDOTDIR/.zcli


### COMPLETION SETTINGS
setopt auto_list		              # 補完候補を一覧表示にする
setopt auto_menu		              # TABで順に補完候補を切り替える
zstyle ':completion:*:default' menu select=2  # 補完一覧をTab/矢印で選択
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# case-insensitive https://qiita.com/watertight/items/2454f3e9e43ef647eb6b
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'
zstyle ':completion:*' completer _complete _ignored _approximate


### HISTORY_SETTINGS
HISTFILE="$XDG_CONFIG_HOME/zsh/.zhistory"
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups     # ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmdを使用する際は無効化
setopt hist_ignore_space        # spaceで始まる場合、コマンド履歴に追加しない
setopt hist_reduce_blanks       # 余分なスペースを削除してヒストリに記録する


### ZINIT SETTINGS
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} \
      Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
zinit wait'0' lucid light-mode for atinit"zicompinit; zicdreplay" \
  zdharma/fast-syntax-highlighting
zinit ice wait'0' lucid blockf light-mode for zsh-users/zsh-completions
zinit wait'0' lucid atload'_zsh_autosuggest_start' light-mode for \
    zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=completion
ZSH_AUTOSUGGEST_USE_ASYNC=1

zinit ice wait'0' lucid as"completion" for \
  https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
  https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws


### STATS
#if (which zprof > /dev/null) ;then
#  zprof | less
#fi
