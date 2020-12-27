augroup myAu
  autocmd!
augroup END

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

" git commit 時にはプラグインは読み込まない
if $HOME != $USERPROFILE && $GIT_EXEC_PATH != ''
  finish
end

" コメント行からの改行時に自動でコメント文字が挿入されるのを抑制
" ref: https://hyuki.hatenablog.com/entry/20140122/vim
autocmd myAu BufEnter * setlocal formatoptions-=r
autocmd myAu BufEnter * setlocal formatoptions-=o

" centered floating window with borders
" ref: https://github.com/neovim/neovim/issues/9718#issuecomment-559573308
function! CreateCenteredFloatingWindow()
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let s:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
  call nvim_open_win(s:buf, v:true, opts)
  set winhl=Normal:Floating
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

augroup MyGroup
  au!
  au BufRead,BufNewFile myPat normal! GAmy text
augroup END

" Automatically install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_shallow = 0
call plug#begin('~/.vim/plugged')
" 0. 全体
Plug 'itchyny/lightline.vim'
Plug 'cocopon/iceberg.vim'
Plug 'joshdick/onedark.vim'
" Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'

" 1. 移動・全文検索・ファイル操作
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture', { 'on': 'Rg' }
Plug 'lambdalisue/fern.vim', { 'on': 'Fern' }
Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'on': 'Fern' }

" 2. エディタ
Plug 'kana/vim-submode'
Plug 'delphinus/vim-auto-cursorline'
Plug '907th/vim-auto-save'

" 3. 文書編集
Plug 'tyru/caw.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
"" スニペット
"" codi.vim?

" 4. LSP
"" Completion
"" Linter
"" Formatter

" 6. 外部連携
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rickhowe/diffchar.vim'
Plug 'tyru/open-browser.vim'
"" プログラム実行

Plug 'airblade/vim-rooter'
call plug#end()

" check the specified plugin is installed
let s:plugs = get(s:, 'plugs', get(g:, 'plugs', {}))
function! IsPlugInstalled(name) abort
  return has_key(s:plugs, a:name) ? isdirectory(s:plugs[a:name].dir) : 0
endfunction
command! -nargs=1 UsePlugin if !IsPlugInstalled(<args>) | finish | endif

if IsPlugInstalled('lightline.vim')
  let g:lightline = {}
endif

runtime! userautoload/*.vim
