let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
"let g:loaded_netrw             = 1
"let g:loaded_netrwPlugin       = 1
"let g:loaded_netrwSettings     = 1
"let g:loaded_netrwFileHandlers = 1
set encoding=utf-8
set number
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set shiftround
set ignorecase
set smartcase
set foldmethod=manual
set foldlevel=999
set ttimeoutlen=10
set updatetime=100
set hidden
set inccommand=split
set mouse=a
set showtabline=2
set laststatus=2
set splitright
set nocursorbind
set noscrollbind
set shortmess+=W
set clipboard=unnamed
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" 折りたたみを維持
" ref: https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
function! s:is_view_available() abort
  if !&buflisted || &buftype !=# ''
    return 0
  elseif !filewritable(expand('%:p'))
    return 0
  endif
  return 1
endfunction
function! s:mkview() abort
  if s:is_view_available()
    silent! mkview
  endif
endfunction
function! s:loadview() abort
  if s:is_view_available()
    silent! loadview
  endif
endfunction
autocmd myau BufWinLeave ?* call s:mkview()
autocmd myau BufReadPost ?* call s:loadview()

" コメント行からの改行時に自動でコメント文字が挿入されるのを抑制
" ref: https://hyuki.hatenablog.com/entry/20140122/vim
autocmd myau BufEnter * setlocal formatoptions-=r
autocmd myau BufEnter * setlocal formatoptions-=o
