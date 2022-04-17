[ -f /proc/sys/fs/binfmt_misc/WSLInterop ] || return

alias open=wslview

export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin"
export PATH="$PATH:/mnt/c/ProgramData/DockerDesktop/version-bin"
export PATH="$PATH:/mnt/c/Windows/System32"
