UsePlugin 'lightline.vim'

" ref: https://kitagry.github.io/blog/programmings/2020/08/lightline-vim-lsp/
function! LightlineLSPWarnings() abort
  let l:counts = lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
  return l:counts.warning == 0 ? '' : printf('W:%d', l:counts.warning)
endfunction

function! LightlineLSPErrors() abort
  let l:counts = lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
  return l:counts.error == 0 ? '' : printf('E:%d', l:counts.error)
endfunction

function! LightlineLSPOk() abort
  let l:counts =  lsp#ui#vim#diagnostics#get_buffer_diagnostics_counts()
  let l:total = l:counts.error + l:counts.warning
  return l:total == 0 ? 'OK' : ''
endfunction

augroup LightLineOnLSP
  autocmd!
  autocmd User lsp_diagnostics_updated call lightline#update()
augroup END

let g:lightline = {
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \   ],
  \   'right': [
  \     [ 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],
  \     [ 'percent' ],
  \     [ 'fileformat', 'fileencoding', 'filetype'  ],
  \   ],
  \ },
  \ 'component_expand': {
  \   'lsp_warnings': 'LightlineLSPWarnings',
  \   'lsp_errors':   'LightlineLSPErrors',
  \   'lsp_ok':       'LightlineLSPOk',
  \ },
  \ 'component_type': {
  \   'lsp_warnings': 'warning',
  \   'lsp_errors':   'error',
  \   'lsp_ok':       'middle',
  \ },
\ }

augroup LightlineColorscheme
  autocmd!
  autocmd ColorScheme * call s:lightline_update()
augroup END

function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    if index([
    \ 'iceberg',
    \ 'wombat',
    \ 'solarized',
    \ 'powerline',
    \ 'powerlineish',
    \ 'jellybeans',
    \ 'molokai',
    \ 'seoul256',
    \ 'darcula',
    \ 'selenized-dark',
    \ 'selenized-black',
    \ 'selenized-light',
    \ 'selenized-white',
    \ 'Tomorrow',
    \ 'Tomorrow-Night',
    \ 'Tomorrow-Night-Blue',
    \ 'Tomorrow-Night-Bright',
    \ 'Tomorrow-Night-Eighties',
    \ 'PaperColor',
    \ 'landscape',
    \ 'one',
    \ 'materia',
    \ 'material',
    \ 'OldHope',
    \ 'nord',
    \ 'deus',
    \ 'simpleblack',
    \ 'srcery-drk',
    \ 'ayu-mirage',
    \ 'ayu-light',
    \ 'ayu-dark',
    \ '16color'
  \ ], g:colors_name) != -1
      let g:lightline.colorscheme =
        \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    endif
  catch
  endtry
endfunction
