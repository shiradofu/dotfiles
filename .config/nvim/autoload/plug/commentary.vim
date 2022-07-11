function! plug#commentary#config() abort
  augroup MyCommentary
    autocmd!
    autocmd FileType toml setlocal commentstring=#\ %s
    autocmd FileType php  setlocal commentstring=//\ %s
    autocmd FileType cpp  setlocal commentstring=//\ %s
  augroup END
endfunction
