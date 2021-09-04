let s:plugin_dir = $XDG_CACHE_HOME . '/dein'
let s:dein_dir = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath^=' . s:dein_dir
endif

function! s:toml(file_name, ...) abort
  let option = a:0 ? a:1 : {}
  let file_path = g:nvim_config_dir . '/toml/' . a:file_name . '.toml'
  call dein#load_toml(file_path, option)
endfunction

MyAutocmd VimEnter * call dein#call_hook('post_source')
MyAutocmd VimEnter * call dein#autoload#_on_default_event('VimEnter')

if dein#load_state(s:plugin_dir)
  call dein#begin(s:plugin_dir)
  call s:toml('fzf')
  call s:toml('lsp')
  call s:toml('textobj')
  call s:toml('findroot')
  call s:toml('lightline')
  call s:toml('git',            { 'lazy': 1 })
  call s:toml('search-replace', { 'lazy': 1 })
  call s:toml('editorconfig',   { 'lazy': 1 })
  call s:toml('edit',           { 'lazy': 1 })
  call s:toml('fern',           { 'lazy': 1 })
  call s:toml('colorscheme',    { 'lazy': 1 })
  call s:toml('vimdoc-ja',      { 'lazy': 1 })
  call s:toml('open-browser',   { 'lazy': 1 })
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
