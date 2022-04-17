[[ ! -f $XDG_STATE_HOME/zinit/zinit.git/zinit.zsh ]] && return

source "$XDG_STATE_HOME/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

ZSH_AUTOSUGGEST_STRATEGY=completion
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(enterkey $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)

zinit wait lucid is-snippet as"completion" for \
  atload"autoload bashcompinit; bashcompinit; complete -C '$(which aws_completer)' aws" \
    https://github.com/aws/aws-cli/blob/v2/bin/aws_zsh_completer.sh
