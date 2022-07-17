augroup MyGroup | autocmd! | augroup END
command! -nargs=* MyAutocmd autocmd MyGroup <args>

" ターミナルでのヤンク時文字化け回避
" https://github.com/neovim/neovim/issues/5683#issuecomment-420833679
lang en_US.UTF-8

set encoding=utf-8            " エンコーディングをUTF-8に設定
set mouse=a                   " マウスを有効化
set showtabline=2             " タブを常に表示
set laststatus=0              " statusline を非表示
set hidden                    " 保存せずにバッファを切り替え可能にする
set splitbelow                " :splitで画面を下に開く
set splitright                " :vsplitで画面を右に開く
set number                    " 左端に行数を表示
set signcolumn=number         " Gitの変更やLSPの警告を行数を上書きして表示
set cursorline                " カーソル行をハイライト
set ignorecase                " 検索時に大文字小文字の差を無視
set smartcase                 " 検索時に大文字が含まれていれば大文字小文字を区別
set inccommand=nosplit        " インクリメンタルサーチの結果をバッファ内でハイライト
set clipboard+=unnamedplus    " システムのクリップボードを使用
set smartindent               " C言語風のプログラミング言語向けの自動インデント
set shiftround                " インデントをshiftwidthの整数倍に揃える
set ttimeoutlen=5             " キーの確定待ちまでの時間
set guicursor+=c:ver10        " コマンドモードのカーソルをビーム形状に（vertical, width 10%)
set diffopt=internal,filler,algorithm:histogram,indent-heuristic " diff の設定
set fileencodings=utf-8,cp932,euc-jp,iso-20220-jp,default,latin  " ファイルエンコーディング候補
set helplang=ja,en            " ヘルプページの言語
set termguicolors             " TUIで24bitカラーを有効にする
set fillchars=vert:\ ,eob:\ , " ステータスライン・バッファの終わりを埋める文字を空白化
set shada+='10000             " 以前に編集したファイルを最大で1000件記憶
set shada-='100               " 以前に編集したファイルの最大記憶数のデフォルト(100件)を除去
set formatoptions+=ro         " 行コメント改行時にコメント文字を自動挿入
set noswapfile                " スワップファイルを無効化

" 不要な機能の無効化
" https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
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

let g:config_dir = $XDG_CONFIG_HOME . '/nvim'
let s:asdf_dir = $ASDF_DATA_DIR . '/installs'
let g:node_host_prog = s:asdf_dir . '/nodejs/lts/.npm/lib/node_modules/neovim/bin/cli.js'

" Log function/command for debugging
function! Log(var) abort
  exe 'redir >> ' g:config_dir . '/log' | silent echo a:var | redir END
endfunction
command! -nargs=1 Log call Log(<args>)

command! -bang -nargs=+ -complete=dir RgIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 0, <bang>0)

command! -bang -nargs=+ -complete=dir RgNoIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 1, <bang>0)

command! RE
  \ execute 'source ' . $MYVIMRC |
  \ call dein#recache_runtimepath() |
  \ echo "loaded"

" run `ulimit -S -n 200048` if fails
" https://github.com/wbthomason/packer.nvim/issues/202#issuecomment-796619161
command! PS PackerSync
command! PC PackerCompile

let mapleader = "\<Space>"

nnoremap <BS>  <Cmd>call user#win#quit()<CR>
nnoremap <Del> <Cmd>bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap g<BS> <Cmd>call user#win#tabclose()<CR>

" nmap     <silent> zz :<C-u>call user#zz#do(1)<CR>
nnoremap <silent> ]q :<C-u>call user#zz#after('cmd', 'cnext')<CR>
nnoremap <silent> [q :<C-u>call user#zz#after('cmd', 'cprev')<CR>
nnoremap <silent> ]c :<C-u>call user#zz#after('map', "\<Plug>(GitGutterNextHunk)")<CR>
nnoremap <silent> [c :<C-u>call user#zz#after('map', "\<Plug>(GitGutterPrevHunk)")<CR>
nmap     <silent> g; :<C-u>call user#zz#after('cmd', 'normal! g;')<CR>
nmap     <silent> g, :<C-u>call user#zz#after('cmd', 'normal! g,')<CR>
nmap f <Plug>(clever-f-f)
xmap f <Plug>(clever-f-f)
omap f <Plug>(clever-f-f)
nmap F <Plug>(clever-f-F)
xmap F <Plug>(clever-f-F)
omap F <Plug>(clever-f-F)
xmap t <Plug>(clever-f-t)
omap t <Plug>(clever-f-t)
xmap T <Plug>(clever-f-T)
omap T <Plug>(clever-f-T)
nnoremap ; <Cmd>FuzzyMotion<CR>
" nmap n  <Cmd>call user#zz#after('mapn', "n")<CR><Cmd>lua require('hlslens').start()<CR>
" nmap N  <Cmd>call user#zz#after('mapn', "n")<CR><Cmd>lua require('hlslens').start()<CR>
nmap n  <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>
nmap N  <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>

nmap <silent> *  <Plug>(asterisk-z*):<C-u>lua require('hlslens').start()<CR>
nmap <silent> g* <Plug>(asterisk-gz*):<C-u>lua require('hlslens').start()<CR>
nmap <silent> #  <Plug>(asterisk-z#):<C-u>lua require('hlslens').start()<CR>
nmap <silent> g# <Plug>(asterisk-gz#):<C-u>lua require('hlslens').start()<CR>
xmap <silent> *  <Plug>(asterisk-z*):<C-u>lua require('hlslens').start()<CR>
xmap <silent> g* <Plug>(asterisk-gz*):<C-u>lua require('hlslens').start()<CR>
xmap <silent> #  <Plug>(asterisk-z#):<C-u>lua require('hlslens').start()<CR>
xmap <silent> g# <Plug>(asterisk-gz#):<C-u>lua require('hlslens').start()<CR>

nnoremap ( ^
nnoremap ) $
nmap     t  <Plug>(operator-replace)
map      Y y$
nnoremap o    o<Cmd>call user#newline#n()<CR>
nnoremap O    O<Cmd>call user#newline#p()<CR>
inoremap <CR> <CR><Cmd>call user#newline#n()<CR>

inoremap , <Cmd>call plug#autopairs#comma()<CR>
inoremap ; <Cmd>call plug#autopairs#semi()<CR>

nnoremap <C-g> <Cmd>ZenMode<CR>

nnoremap <silent> go :<C-u>call user#win#move(v:count)<CR>
nnoremap <silent> gh :<C-u>call user#win#focus_float()<CR>

nnoremap <silent> gb :<C-u>edit #<CR>
nnoremap <silent> gy :<C-u>let @+=expand('%')<CR>
nnoremap <silent> gY :<C-u>let @+=expand('%:p')<CR>
nnoremap <silent> gz :<C-u>Goyo 100<CR>
nmap     <silent> gx <Plug>(openbrowser-smart-search)
vmap     <silent> gx <Plug>(openbrowser-smart-search)

nnoremap <silent> <Leader>w :<C-u>w<CR>
nnoremap <silent> <Leader>r :<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader><C-r> :<C-u>vs<CR>:<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader>t :<C-u>call fzf#sonictemplate#run()<CR>
nnoremap <silent> <Leader>o :<C-u>ProjectMru<CR>
nnoremap <silent> <Leader>i :<C-u>Files<CR>
nnoremap <silent> <Leader>u :<C-u>GFiles?<CR>
" nnoremap <Leader>f :<C-u>RgIgnore<Space>
" vnoremap <Leader>f :<C-u>call user#rg#visual('RgIgnore')<CR>
" nnoremap <expr> <Leader>g ':<C-u>RgIgnore ' . user#rg#cword() . '<CR>'
" vnoremap <Leader>g :<C-u>call user#rg#visual('RgIgnore')<CR><CR>
nnoremap <Leader>f :<C-u>FzfLua live_grep_glob<CR>
nnoremap <Leader>F :<C-u>RgNoIgnore<Space>
vnoremap <Leader>f <Cmd>FzfLua grep_visual<CR>
vnoremap <Leader>F :<C-u>call user#rg#visual('RgNoIgnore')<CR>
nnoremap <Leader>g <Cmd>FzfLua grep_cword<CR>
nnoremap <expr> <Leader>G ':<C-u>RgNoIgnore ' . user#rg#cword() . '<CR>'
vnoremap <Leader>g <Cmd>FzfLua grep_visual<CR>
vnoremap <Leader>G :<C-u>call user#rg#visual('RgNoIgnore')<CR><CR>
nnoremap <silent> <Leader>: :<C-u>History:<CR>
nnoremap <silent> <Leader>q :<C-u>botright copen<CR>
nnoremap <silent> <Leader>d :<C-u>DiffviewOpen -- %<CR>
nnoremap <silent> <Leader>s :<C-u>call user#win#goto_or('Git status', 'DiffviewOpen')<CR>
nnoremap <silent> <Leader>S :<C-u>DiffviewOpen main<CR>
nnoremap <silent> <Leader>y :<C-u>DiffviewFileHistory %<CR>
nnoremap <silent> <Leader>Y :<C-u>DiffviewFileHistory<CR>
nnoremap <silent> <Leader>b :<C-u>Git blame<CR>
nnoremap <silent> <Leader>B :<C-u>OpenGithubFile<CR>
vnoremap <silent> <Leader>B :OpenGithubFile<CR>
nnoremap <silent> <Leader>, :<C-u>Gin commit<CR>
nnoremap <silent> <Leader>. :<C-u>Gin push<CR>
nnoremap <silent> <Leader>l :<C-u>SymbolsOutline<CR>
nnoremap <Leader>p <Cmd>call print_debug#print_debug()<CR>
nnoremap <Leader>e <Cmd>Trouble<CR>

nnoremap cl "_cl
nnoremap ch "_ch

xmap s <Plug>Commentary
nmap s <Plug>Commentary
omap s <Plug>Commentary
nmap S <Plug>Commentary<Plug>Commentary
" invert
xnoremap S <Cmd>let b:S = @/<CR>:g/./Commentary<CR><Cmd>nohl<CR><Cmd>let @/ = b:S<CR>

nmap gs <Plug>(sandwich-add)
xmap gs <Plug>(sandwich-add)
omap gs <Plug>(sandwich-add)
nmap ds <Plug>(sandwich-delete)
nmap dss <Plug>(sandwich-delete-auto)
nmap cs <Plug>(sandwich-replace)
nmap css <Plug>(sandwich-replace-auto)

nnoremap t  <Cmd>lua require('substitute').operator()<CR>
nnoremap T  <Cmd>lua require('substitute').eol()<CR>
xnoremap P  <Cmd>lua require('substitute').visual()<CR>
nnoremap X  <Cmd>lua require('substitute.exchange').operator()<CR>
xnoremap X  <Cmd>lua require('substitute.exchange').visual()<CR>
nnoremap Xx <Cmd>lua require('substitute.exchange').cancel()<CR>

nmap gl     <Plug>(quickhl-manual-this)
xmap gl     <Plug>(quickhl-manual-this)
nmap gL     <Plug>(quickhl-manual-reset)
xmap gL     <Plug>(quickhl-manual-reset)
nmap g<C-l> <Plug>(quickhl-cword-toggle)

nnoremap mv :<C-u>CocCommand workspace.renameCurrentFile<CR>

noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-d> <Del>
noremap! <C-y> <C-r>+
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-k> <C-o>D
cnoremap <C-o> <Up>
cnoremap <C-i> <Down>
cnoremap <Tab> <Down>
cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>
cnoremap <C-x> <C-r>=expand('%:p')<CR>
snoremap <BS> <BS>i
snoremap <C-h> <C-h>i

MyAutocmd FileType qf
\   nnoremap <buffer> ; <CR>zz<C-w>p
\ | nnoremap <silent> <buffer> dd :<C-u>call user#quickfix#del()<CR>
\ | nnoremap <silent> <buffer> u  :<C-u>call user#quickfix#undo_del()<CR>
\ | nnoremap <silent> <buffer> R  :<C-u>Qfreplace topleft split<CR>

augroup MyMarkdown
  autocmd!
  " inoremap: bulletの行でTabを押すとインデントを追加
  autocmd FileType markdown
  \ setlocal conceallevel=0
  \ | inoremap <expr><buffer> <Tab> getline('.') =~ '^\s*- .*' ? "\<C-t>" : "\<Tab>"
  \ | nmap <Leader><CR> <Plug>MarkdownPreviewToggle
  \ | nnoremap <C-x> <Cmd>call plug#checkbox#toggle()<CR>
  \ | inoremap <C-x> <Cmd>call plug#checkbox#toggle()<CR>
  " autocmd Syntax markdown syntax on
  autocmd Syntax markdown syntax match checkedItem containedin=ALL '\v\s*(-\s+)?\[x\]\s+.*'
  autocmd Syntax markdown hi link checkedItem Comment
augroup END

augroup MyRest
  autocmd FileType http nmap <buffer> <CR> <Plug>RestNvim
augroup END

nnoremap <Leader>k <Cmd>lua require("duck").hatch('🫀')<CR>
nnoremap <Leader>K <Cmd>lua require("duck").cook()<CR>

call plugins#load()

lua require'user.mappings'
lua require'user.options'
lua require'plugins'

augroup MyGitCommit
  autocmd!
  au BufWinEnter .git/COMMIT_EDITMSG startinsert
augroup END

augroup MyCommentString
  autocmd!
  autocmd FileType toml setlocal commentstring=#\ %s
  autocmd FileType php  setlocal commentstring=//\ %s
  autocmd FileType cpp  setlocal commentstring=//\ %s
augroup END

augroup MyDotenv
  autocmd!
  autocmd BufEnter .env.* setlocal ft=sh
augroup END

" TODO: default に戻す
se bg=dark
let s:colorscheme = !empty($COLORSCHEME) ? $COLORSCHEME : 'nord'
exe 'colorscheme ' . s:colorscheme
