! $IS_WSL && return

open() { powershell.exe /c start $(wslpath -w $1) }
