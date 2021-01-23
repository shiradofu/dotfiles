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
  \     [ 'readonly', 'filename', 'modified' ],
  \   ],
  \   'right': [
  \     [ 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],
  \     [ 'percent' ],
  \     [ 'fileformat', 'fileencoding', 'filetype'  ],
  \   ],
  \ },
  \ 'tabline': {
  \   'left': [
  \     [ 'tabs' ],
  \   ],
  \   'right': [
  \     [],
  \     [ 'gitbranch' ],
  \     [],
  \   ],
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
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
    let l:formatted_colors_name =
    \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
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
    \ 'selenized_dark',
    \ 'selenized_black',
    \ 'selenized_light',
    \ 'selenized_white',
    \ 'Tomorrow',
    \ 'Tomorrow_Night',
    \ 'Tomorrow_Night_Blue',
    \ 'Tomorrow_Night_Bright',
    \ 'Tomorrow_Night_Eighties',
    \ 'PaperColor',
    \ 'landscape',
    \ 'one',
    \ 'materia',
    \ 'material',
    \ 'OldHope',
    \ 'nord',
    \ 'deus',
    \ 'simpleblack',
    \ 'srcery_drk',
    \ 'ayu_mirage',
    \ 'ayu_light',
    \ 'ayu_dark',
    \ '16color'
  \ ], l:formatted_colors_name) != -1
      let g:lightline.colorscheme = l:formatted_colors_name
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    endif
  catch
  endtry
endfunction
