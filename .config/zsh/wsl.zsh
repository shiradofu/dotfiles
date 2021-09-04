! $IS_WSL && return

open() { cmd.exe /c start $(wslpath -w $1) }
