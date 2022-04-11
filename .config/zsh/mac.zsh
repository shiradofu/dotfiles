! $IS_MAC && return

PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"

PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnuman:$MANPATH"

PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnuman:$MANPATH"

PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnuman:$PATH"

PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman:$MANPATH"

PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
MANPATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnuman:$MANPATH"

export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include"
