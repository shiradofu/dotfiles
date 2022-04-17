augroup MyGroup | autocmd! | augroup END
command! -nargs=* MyAutocmd autocmd MyGroup <args>

"
" setting options
"
set encoding=utf-8
set mouse=a
set showtabline=2
set hidden
set splitbelow
set splitright
set number
set signcolumn=number
" set colorcolumn=80,100
set cursorline
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
MyAutocmd FileType markdown setlocal conceallevel=0

"
" disable unnecessary features
"
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
let g:loaded_ruby_provider     = 0
let g:loaded_perl_provider     = 0
let g:loaded_python3_provider  = 0
let g:vim_json_conceal         = 0
let g:vim_markdown_conceal     = 0

let s:config_dir = $XDG_CONFIG_HOME . '/nvim'
let s:cache_dir = $XDG_CACHE_HOME . '/nvim'
let g:init_vim_path = s:config_dir . '/init.vim'
let s:asdf_dir = $ASDF_DATA_DIR . '/installs'
let g:node_host_prog = s:asdf_dir . '/nodejs/lts/.npm/lib/node_modules/neovim/bin/cli.js'

function! Log(var) abort
  exe "redir >> " s:cache_dir . "/log" | silent echo a:var | redir END
endfunction
command! -nargs=1 Log call Log(<args>)

"
" load colorscheme setting
"
runtime! _colorscheme.vim
let g:colorscheme = get(g:, 'colorscheme', 'default')

"
" load plugins
"
let s:plugin_dir = $XDG_STATE_HOME . '/nvim/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath^=' . s:dein_dir

MyAutocmd VimEnter * call dein#call_hook('post_source')
MyAutocmd VimEnter * call dein#autoload#_on_default_event('VimEnter')

if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)
  call dein#add(s:dein_dir)
  call dein#load_toml(s:config_dir . '/toml/basic.toml')
  call dein#load_toml(s:config_dir . '/toml/lazy.toml', { 'lazy': 1 })
  call dein#add('sheerun/vim-polyglot')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

if !has('vim_starting')
  let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif
endif

"
" load other configurations
"
runtime! user/*.vim
