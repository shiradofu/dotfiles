let mapleader = "\<Space>"

nnoremap <silent> <Leader>; :<C-u>execute 'source ' . g:init_vim_path<CR>
\ :<C-u>call dein#recache_runtimepath()<CR>:<C-u>echo "loaded"<CR>

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
nnoremap <silent> ]e :<C-u>call user#util#zi_after("call CocAction('diagnosticNext')")<CR>
nnoremap <silent> [e :<C-u>call user#util#zi_after("call CocAction('diagnosticPrevious')")<CR>
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
nnoremap go <C-w>T
nnoremap Z <C-w>+
nnoremap Q <C-w>-
nnoremap \| 2<C-w><
nnoremap \ 2<C-w>>
nnoremap ¥ 2<C-w>>
nnoremap g. <C-w>_<C-w>\|
nnoremap g/ <C-w>=

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

nnoremap <silent> <Leader>t :<C-u>vs<CR>:<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader>T :<C-u>vs<CR>:<C-u>Fern .<CR>
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
nnoremap <silent> <Leader>r :<C-u>Qfreplace topleft split<CR>
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
