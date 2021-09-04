augroup MyGroup | autocmd! | augroup END
command! -nargs=* MyAutocmd autocmd MyGroup <args>

set encoding=utf-8
set mouse=a
set showtabline=2
set hidden
set splitbelow
set splitright
set number
set signcolumn=number
set colorcolumn=80,100
set cursorline
set conceallevel=0
set ignorecase
set smartcase
set inccommand=nosplit
set clipboard+=unnamedplus
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set shiftround
set ttimeoutlen=10
set updatetime=100
set guicursor+=c:ver10
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
set fileencodings=utf-8,cp932,euc-jp,iso-20220-jp,default,latin
set helplang=ja,en
set termguicolors
set fillchars=vert:\ ,eob:\ ,
set viminfo+='10000
set viminfo-='100

MyAutocmd BufEnter * setlocal formatoptions-=r
MyAutocmd BufEnter * setlocal formatoptions-=o
MyAutocmd BufEnter * setlocal conceallevel=0

let s:asdf_dir = $HOME . '/.asdf/installs'
let g:python_host_prog = s:asdf_dir . '/python/2.7.18/bin/python'
let g:python3_host_prog = s:asdf_dir . '/python/3.9.6/bin/python'
let g:node_host_prog = s:asdf_dir . '/nodejs/lts/.npm/lib/node_modules/neovim/bin/cli.js'
let g:nvim_config_dir = $XDG_CONFIG_HOME . '/nvim'
let g:init_vim_path = g:nvim_config_dir . '/init.vim'

function! Log(var) abort
  exe "redir >> " g:nvim_config_dir . "/log" | silent echo a:var | redir END
endfunction
command! -nargs=1 Log call Log(<args>)

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
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:vim_json_conceal         = 0
let g:vim_markdown_conceal     = 0

runtime! _colorscheme.vim
let g:colorscheme = get(g:, 'colorscheme', 'default')

runtime! dein.vim
runtime! user/*.vim
