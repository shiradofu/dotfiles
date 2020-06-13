augroup myau
  autocmd!
augroup END

" for only neovim. in pyenv virtualenv named 'neovim-python3'
if has('nvim') && isdirectory( $PYENV_ROOT."/versions/neovim-python3" )
  let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim-python3/bin/python'
endif

" プラグインがインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" dein.vim がなければ github から取得
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

let g:config_dir = $XDG_CONFIG_HOME . '/nvim/'
if dein#load_state(s:dein_dir)
  let s:dein_toml = g:config_dir . 'dein.toml'
  let s:deinlazy_toml = g:config_dir . 'deinlazy.toml'
  let s:deinft_toml = g:config_dir . 'deinft.toml'
  call dein#begin(s:dein_dir, [expand('<sfile>'), s:dein_toml, s:deinlazy_toml])
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#load_toml(s:dein_toml, { 'lazy': 0 })
  call dein#load_toml(s:deinlazy_toml, { 'lazy': 1 })
  call dein#load_toml(s:deinft_toml)
  call dein#end()
  call dein#save_state()
endif
if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
filetype plugin indent on
syntax enable

runtime! userautoload/*.vim

" mtth/scratch.vim
let g:scratch_no_mappings = 1
let g:scratch_horizontal = 1
let g:scratch_height = 999
let g:scratch_autohide = 0
let g:scratch_persistence_file = '.scratch-vim'
nnoremap <silent> gs :<C-u>Scratch<CR>gg
command! -nargs=0 ScratchClose call ScratchClose()
function! ScratchClose()
  if strlen(g:scratch_persistence_file) > 0
    execute ':w ' . g:scratch_persistence_file
  endif
  close
endfunction
autocmd myau FileType scratch nnoremap <silent> <buffer> <Esc> :<C-u>ScratchClose<CR>

call plug#begin('~/.local/share/nvim/plugged')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'mtth/scratch.vim'
call plug#end()
nnoremap <silent> sf :Files<CR>


