augroup myau
  autocmd!
augroup END

" ref: https://qiita.com/kawaz/items/ee725f6214f91337b42b
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein' " dir for plugin entities
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  let s:toml_dir = fnamemodify(expand('<sfile>'), ':h').'/dein'
  call dein#load_toml(s:toml_dir . '/general.toml', { 'lazy': 0 })
  call dein#load_toml(s:toml_dir . '/lazy.toml',    { 'lazy': 1 })
  call dein#load_toml(s:toml_dir . '/filetype.toml')
  call dein#end()
  call dein#save_state()
endif
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
filetype plugin indent on
syntax enable

" tomlファイル内のvimscriptハイライト
" ref: https://qiita.com/tmsanrinsha/items/9670628aef3144c7919b
if dein#tap('vim-SyntaxRange')
  autocmd myau BufNewFile,BufRead *.toml call s:syntax_range_dein()
  function! s:syntax_range_dein() abort
    let start = '^\s*hook_\%('.
    \           'add\|source\|post_source\|post_update'.
    \           '\)\s*=\s*%s'
    call SyntaxRange#Include(printf(start, "'''"), "'''", 'vim', '')
    call SyntaxRange#Include(printf(start, '"""'), '"""', 'vim', '')
  endfunction
endif

runtime! userautoload/*.vim
