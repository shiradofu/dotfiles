let s:state_home = empty($XDG_STATE_HOME) ? expand('~/.local/state') : $XDG_STATE_HOME
let s:plugin_dir = s:state_home . '/nvim/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

function! s:manager_installed() abort
  if !isdirectory(s:dein_dir)
    echoerr "dein.vim is not installed."
    return v:false
  endif
  return v:true
endfunction

if s:manager_installed()
  execute 'set runtimepath^=' . s:dein_dir
endif

let s:_old = g:config_dir . '/_old.toml'

function! plugins#load() abort
  if !s:manager_installed() | return | endif
  " if dein#load_state(s:plugin_dir)
    call dein#begin(s:plugin_dir)
    call dein#add(s:dein_dir)
    call dein#load_toml(g:config_dir . '/_old.toml', { 'lazy': 1 })
    call dein#end()
    " call dein#save_state()
  " endif

  filetype plugin indent on
  " syntax enable

  if dein#check_install()
    call dein#install()
  endif
endfunction

function! plugins#del() abort
  if !s:manager_installed() | return | endif
  let l:removed = dein#check_clean()
  if len(l:removed) > 0
    call map(l:removed, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif
endfunction
