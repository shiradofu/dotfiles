function! plug#commentary#hook_add() abort
  augroup CommentaryHookAdd | autocmd! | augroup END
  xmap s <Plug>Commentary
  nmap s <Plug>Commentary
  omap s <Plug>Commentary
  nmap S <Plug>Commentary<Plug>Commentary
  autocmd CommentaryHookAdd FileType toml setlocal commentstring=#\ %s
  autocmd CommentaryHookAdd FileType php  setlocal commentstring=//\ %s
endfunction
