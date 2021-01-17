UsePlugin 'fern.vim'

let g:fern#default_hidden = 1

function! s:init_fern() abort
  nmap <buffer> s <Nop>
  nmap <buffer> S <Plug>(fern-action-open:select)
  nmap <buffer> <BS> :<C-u>q<CR>
endfunction

augroup my-fern
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
