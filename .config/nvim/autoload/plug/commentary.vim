function! plug#commentary#hook_add() abort
  xmap s <Plug>Commentary
  nmap s <Plug>Commentary
  omap s <Plug>Commentary
  nmap S <Plug>Commentary<Plug>Commentary
  MyAutocmd FileType toml setlocal commentstring=#\ %s
  MyAutocmd FileType php  setlocal commentstring=//\ %s
endfunction
