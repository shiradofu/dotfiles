if !filereadable('/proc/sys/fs/binfmt_misc/WSLInterop')
  finish
endif

autocmd TextYankPost * call system('clip.exe', @")
