! $IS_MAC && return

PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"

PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

PATH="/usr/local/opt/gawk/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gawk/libexec/gnuman:$PATH"

PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
