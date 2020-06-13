### GENERAL SETTINGS
set -o noclobber


### ALIAS SETTINGS
# https://lists.gnu.org/archive/html/bug-bash/2006-01/msg00018.html
# source does not work in conjunction with process substit
if [ -f $XDG_CONFIG_HOME/zsh/.zalias ]; then
  alias bashrc='source ~/.bashrc && echo "function"'
  source /dev/stdin <<<"$(awk '/### alias/,/### end of alias/' $XDG_CONFIG_HOME/zsh/.zalias)"
fi


### PROMPT SETTINGS
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


### COMPLETION SETTINGS
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


### HISTORY SETTINGS
export HISTSIZE=1000
export HISTCONTROL=ignoreboth
shopt -s histappend


### FZF SETTINGS
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


### ANYENV SETTINGS
eval "$(anyenv init - --no-rehash)"
