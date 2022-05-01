let s:plugin_dir = $XDG_STATE_HOME . '/nvim/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath^=' . s:dein_dir

MyAutocmd VimEnter * call dein#call_hook('post_source')
MyAutocmd VimEnter * call dein#autoload#_on_default_event('VimEnter')

" if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)
  call dein#add(s:dein_dir)
  call dein#load_toml(g:config_dir . '/dein.toml')
  call dein#load_toml(g:config_dir . '/dein_lazy.toml', { 'lazy': 1 })
  call dein#end()
  call dein#save_state()
" endif

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
