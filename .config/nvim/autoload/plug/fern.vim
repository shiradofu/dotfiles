function plug#fern#hook_source() abort
  let g:fern#disable_default_mappings  = 1
  let g:fern#default_hidden = 1
  let s:fern_starship_like_path = ''

  function! FernLcd() abort
    let dir = substitute(expand('%:p'), '.\+file:\/\/\(.\+\)\$$', '\1', '')
    exe 'lcd ' . dir
    let s:fern_starship_like_path = dir
    let project_root = trim(system('git rev-parse --show-toplevel'))
    if project_root !~# 'fatal: not a git repository'
      exe 'lcd ' . project_root
      let s:fern_starship_like_path =
      \ fnamemodify(project_root, ':t') .
      \ substitute(expand('%:p'), '.\+file:\/\/' . project_root . '\(.*\)\$$', '\1', '')
    endif
  endfunction

  function! FernStarshipLikePath(fallback) abort
    return get(s:, 'fern_starship_like_path', a:fallback)
  endfunction

  function! InitFern() abort
    setlocal signcolumn=number
    nnoremap <silent> <BS> :<C-u>q<CR>
    nmap <buffer> <C-c> <Plug>(fern-action-cancel)
    nmap <buffer> yy    <Plug>(fern-action-clipboard-copy)
    nmap <buffer> Y     <Plug>(fern-action-clipboard-copy)
    nmap <buffer> cc    <Plug>(fern-action-clipboard-move)
    nmap <buffer> C     <Plug>(fern-action-clipboard-move)
    nmap <buffer> p     <Plug>(fern-action-clipboard-paste)
    nmap <buffer> h     <Plug>(fern-action-collapse)
    nmap <buffer> D     <Plug>(fern-action-copy)
    nmap <buffer> gu    <Plug>(fern-action-leave)
    nmap <buffer> v     <Plug>(fern-action-mark)
    vmap <buffer> v     <Plug>(fern-action-mark)
    nmap <buffer> N     <Plug>(fern-action-new-path)
    nmap <buffer> <CR>  <Plug>(fern-action-open-or-enter)
    nmap <buffer> l     <Plug>(fern-action-open-or-expand)
    nmap <buffer> <C-r> <Plug>(fern-action-reload)
    nmap <buffer> dd    <Plug>(fern-action-remove)
    nmap <buffer> R     <Plug>(fern-action-rename)
    call FernLcd()
  endfunction
  MyAutocmd FileType fern call InitFern()
endfunction
