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
  call dein#load_toml(s:config_dir . '/dein.toml')
  call dein#load_toml(s:config_dir . '/dein_lazy.toml', { 'lazy': 1 })
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
" commands and keymaps
"
command! -bang -nargs=+ -complete=dir RgIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 0, <bang>0)

command! -bang -nargs=+ -complete=dir RgNoIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 1, <bang>0)

nnoremap <silent> <Plug>(user-util-set_should_zi)
  \ :<C-u>call user#util#set_should_zi()<CR>

let mapleader = "\<Space>"
nnoremap <silent> <Leader>; :<C-u>execute 'source ' . g:init_vim_path<CR>
\ :<C-u>call dein#recache_runtimepath()<CR>:<C-u>echo "loaded"<CR>

inoremap <silent> jj <Esc>
nnoremap <silent> <BS>  :<C-u>call user#util#quit()<CR>
nnoremap <silent> g<BS> :<C-u>call user#util#tabclose()<CR>
nmap     <silent> zi    :<C-u>call user#util#zi()<CR>
nnoremap <silent> <expr> <C-g> (float2nr(winheight(win_getid()) * 0.25) - 1) . 'j'
nnoremap <silent> <expr> <C-t> (float2nr(winheight(win_getid()) * 0.25) - 1) . 'k'
vnoremap <silent> <expr> <C-g> (float2nr(winheight(win_getid()) * 0.25) - 1) . 'j'
vnoremap <silent> <expr> <C-t> (float2nr(winheight(win_getid()) * 0.25) - 1) . 'k'
nnoremap <silent> ]q :<C-u>call user#util#zi_after('cnext')<CR>
nnoremap <silent> [q :<C-u>call user#util#zi_after('cprev')<CR>
nnoremap <silent> ]c :<C-u>call user#util#zi_after('call feedkeys("\<Plug>(GitGutterNextHunk)", "m")')<CR>
nnoremap <silent> [c :<C-u>call user#util#zi_after('call feedkeys("\<Plug>(GitGutterPrevHunk)", "m")')<CR>
nnoremap <silent> ]w :<C-u>call user#util#zi_after("call CocAction('diagnosticNext')")<CR>
nnoremap <silent> [w :<C-u>call user#util#zi_after("call CocAction('diagnosticPrevious')")<CR>
nnoremap <silent> ]e :<C-u>call user#util#zi_after("call CocAction('diagnosticNext')")<CR>e
nnoremap <silent> [e :<C-u>call user#util#zi_after("call CocAction('diagnosticPrevious')")<CR>e
nmap     <silent> g; :<C-u>call user#util#zi_after('normal! g;')<CR>
nmap     <silent> g, :<C-u>call user#util#zi_after('normal! g,')<CR>
nmap     <silent> <C-o> :<C-u>call user#util#zi_after('call feedkeys("\<C-o>", "n")')<CR>
nmap     <silent> <C-i> :<C-u>call user#util#zi_after('call feedkeys("\<C-i>", "n")')<CR>
nmap     <silent> n :<C-u>call user#util#zi_after('call feedkeys("\<Plug>(is-n)", "m")')<CR>
nmap     <silent> N :<C-u>call user#util#zi_after('call feedkeys("\<Plug>(is-N)", "m")')<CR>
map      *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map      g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map      #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map      g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
nmap     t <Plug>(operator-replace)
map      Y y$
xmap     if <Plug>(coc-funcobj-i)
omap     if <Plug>(coc-funcobj-i)
xmap     af <Plug>(coc-funcobj-a)
omap     af <Plug>(coc-funcobj-a)

nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-n> gt
nnoremap <C-p> gT
nnoremap Z <C-w>+
nnoremap Q <C-w>-
nnoremap \| 2<C-w><
nnoremap \ 2<C-w>>
nnoremap ¥ 2<C-w>>
nnoremap g. <C-w>_<C-w>\|
nnoremap g/ <C-w>=
nnoremap <silent> go :<C-u>call user#util#winmove(v:count)<CR>
nnoremap <silent> g[ :<C-u>-tabm<CR>
nnoremap <silent> g] :<C-u>+tabm<CR>

nnoremap <silent> gb :<C-u>edit #<CR>
nnoremap <silent> gy :<C-u>let @+=expand('%')<CR>
nnoremap <silent> gY :<C-u>let @+=expand('%:p')<CR>
nnoremap <silent> gz :<C-u>Goyo 100<CR>
nnoremap <silent> gs :<C-u>call user#scratch#open()<CR>
nmap     <silent> gx <Plug>(openbrowser-smart-search)
vmap     <silent> gx <Plug>(openbrowser-smart-search)
nmap     <silent> gh <Plug>(coc-float-jump)
nnoremap <silent> gd :<C-u>call CocAction('jumpDefinition')<CR>
nnoremap <silent> gD :<C-u>call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> gt :<C-u>call CocAction('jumpTypeDefinition')<CR>
nnoremap <silent> gT :<C-u>call CocAction('jumpTypeDefinition', 'vsplit')<CR>
nnoremap <silent> gr :<C-u>call CocActionAsync('rename')<CR>
nnoremap <silent> ga :<C-u>CocAction<CR>

nnoremap <silent> <Leader>r :<C-u>:<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader><C-r> :<C-u>vs<CR>:<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader>R :<C-u>vs<CR>:<C-u>Fern .<CR>
nnoremap <silent> <Leader>o :ProjectMru<CR>
nnoremap <silent> <Leader>i :Files<CR>
nnoremap <silent> <Leader>u :GFiles?<CR>
nnoremap <Leader>f :<C-u>RgIgnore<Space>
nnoremap <Leader>F :<C-u>RgNoIgnore<Space>
vnoremap <Leader>f :<C-u>call user#rg#visual('RgIgnore')<CR>
vnoremap <Leader>F :<C-u>call user#rg#visual('RgNoIgnore')<CR>
nnoremap <expr> <Leader>g ':<C-u>RgIgnore ' . user#rg#cword() . '<CR>'
nnoremap <expr> <Leader>G ':<C-u>RgNoIgnore ' . user#rg#cword() . '<CR>'
vnoremap <Leader>g :<C-u>call user#rg#visual('RgIgnore')<CR><CR>
vnoremap <Leader>G :<C-u>call user#rg#visual('RgNoIgnore')<CR><CR>
nnoremap <silent> <Leader>: :<C-u>History:<CR>
nnoremap <silent> <Leader>q :<C-u>botright copen<CR>
nnoremap <silent> <Leader>d :<C-u>tabnew<CR><C-o>:<C-u>Gdiffsplit<CR>
nnoremap <silent> <Leader>s
\ :<C-u>call user#util#gotowin_or('.git/index', 'tabnew \| Git! \| wincmd K')<CR>
nnoremap <silent> <Leader>b :<C-u>Git blame<CR>
nnoremap <silent> <Leader>B :<C-u>GBrowse<CR>
vnoremap <silent> <Leader>B :GBrowse<CR>
nnoremap <silent> <Leader>, :<C-u>Git commit \| startinsert<CR>
nnoremap <silent> <Leader>. :<C-u>Dispatch! git push<CR>
nmap     <silent> <Leader>n <Plug>(coc-references)
nmap     <silent> <Leader>m <Plug>(coc-implementation)
nnoremap <silent> <Leader>e :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> <Leader>y :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <Leader>l :<C-u>Vista!!<CR>

nmap gc <nop>
nnoremap <silent> gcc :<C-u>CamelB<CR>:call repeat#set("gcc")<CR>
nnoremap <silent> gcC :<C-u>Camel<CR>:call repeat#set("gcC")<CR>
nnoremap <silent> gcs :<C-u>Snek<CR>:call repeat#set("gcs")<CR>
nnoremap <silent> gck :<C-u>Kebab<CR>:call repeat#set("gck")<CR>
xnoremap <silent> gcc :CamelB<CR>:call repeat#set("gcc")<CR>
xnoremap <silent> gcC :Camel<CR>:call repeat#set("gcC")<CR>
xnoremap <silent> gcs :Snek<CR>:call repeat#set("gcs")<CR>
xnoremap <silent> gck :Kebab<CR>:call repeat#set("gck")<CR>

nmap md <C-p> <Plug>MarkdownPreviewToggle
nnoremap mv :<C-u>CocCommand workspace.renameCurrentFile<CR>
nnoremap <silent> K :call CocShowDocumentation()<CR>
inoremap <silent><expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"

noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-d> <Del>
noremap! <C-y> <C-r>+
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-k> <C-o>D
cnoremap <expr> <C-p> pumvisible() ? "\<Left>" : "\<Up>"
cnoremap <expr> <C-n> pumvisible() ? "\<Right>" : "\<Down>"
cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>
cnoremap <C-x> <C-r>=expand('%:p')<CR>

MyAutocmd FileType qf
\   nnoremap <buffer> p <CR>zi<C-w>p
\ | nnoremap <silent> <buffer> dd :<C-u>call user#quickfix#del()<CR>
\ | nnoremap <silent> <buffer> u  :<C-u>call user#quickfix#undo_del()<CR>
\ | nnoremap <silent> <buffer> R  :<C-u>Qfreplace topleft split<CR>

if index(getcompletion('', 'color'), g:colorscheme) == -1
  finish
endif

"
" additional colorscheme settings
"
MyAutocmd ColorScheme *
\   highlight Normal          ctermbg=none guibg=none
\ | highlight EndOfBuffer     ctermbg=none guibg=none
\ | highlight LineNr          ctermbg=none guibg=none
\ | highlight CursorLineNr    ctermbg=none guibg=none
\ | highlight SignColumn      ctermbg=none guibg=none
\ | highlight GitGutterAdd    ctermbg=none guibg=none
\ | highlight GitGutterChange ctermbg=none guibg=none
\ | highlight GitGutterDelete ctermbg=none guibg=none
\ | highlight VertSplit       ctermfg=none guifg=none
\ | highlight CursorLine      ctermbg=none guibg=none gui=underline
\ | highlight clear DiffAdd
\ | highlight clear DiffDelete
\ | highlight clear DiffChange
\ | highlight clear DiffText


if g:colorscheme ==# 'iceberg'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#45493e               |
  \ highlight DiffDelete guibg=#53343b guifg=#53343b |
  \ highlight DiffChange guibg=#384851               |
  \ highlight DiffText   guibg=#0f324d gui=bold
elseif g:colorscheme ==# 'nord'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#2e4159               |
  \ highlight DiffText   guibg=#19283b gui=bold
elseif g:colorscheme ==# 'hydrangea'
  MyAutocmd ColorScheme *
  \ highlight ColorColumn guibg=#421424              |
  \ highlight GitGutterChange guifg=#996ddb          |
  \ highlight DiffAdd    guibg=#043a4a               |
  \ highlight DiffDelete guibg=#4f0539 guifg=#4f0539 |
  \ highlight DiffChange guibg=#2a4275               |
  \ highlight DiffText   guibg=#0b2e7a gui=bold
elseif g:colorscheme ==# 'mirodark'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#002529               |
  \ highlight DiffDelete guibg=#2e012b guifg=#2e012b |
  \ highlight DiffChange guibg=#14113d               |
  \ highlight DiffText   guibg=#000000 gui=bold
elseif g:colorscheme ==# 'gotham'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#043327               |
  \ highlight DiffDelete guibg=#451714 guifg=#451714 |
  \ highlight DiffChange guibg=#0a3749               |
  \ highlight DiffText   guibg=#091f2e gui=bold
elseif g:colorscheme ==# 'farout'
  MyAutocmd ColorScheme *
  \ highlight CursorLineNr guifg=#F2DDBC             |
  \ highlight CursorLine   guibg=#2F1D1A             |
  \ highlight ColorColumn  guibg=#2F1D1A             |
  \ highlight DiffAdd    guibg=#142903               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#302c01 gui=bold
elseif g:colorscheme ==# 'mellow'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#1c3804               |
  \ highlight DiffDelete guibg=#401a1e guifg=#401a1e |
  \ highlight DiffChange guibg=#4a400c               |
  \ highlight DiffText   guibg=#362d02 gui=bold
elseif g:colorscheme ==# 'monotone'
  MyAutocmd ColorScheme *
  \ highlight DiffAdd    guibg=#333332               |
  \ highlight DiffDelete guibg=#333333 guifg=#333333 |
  \ highlight DiffChange guibg=#333333               |
  \ highlight DiffText   guibg=#222222 gui=bold
  " \ highlight DiffAdd    guibg=#3e5432               |
  " \ highlight DiffDelete guibg=#693e30 guifg=#693e30 |
  " \ highlight DiffChange guibg=#3a455c               |
  " \ highlight DiffText   gui=inverse,bold
endif

exe 'colorscheme ' . g:colorscheme

if g:colorscheme ==# 'mirodark'
  let g:lightline.colorscheme = 'apprentice'
elseif g:colorscheme ==# 'monotone'
  let g:lightline.colorscheme = 'jellybeans'
else
  let g:lightline.colorscheme = g:colorscheme
endif

call lightline#init()
call lightline#colorscheme()
call lightline#update()
