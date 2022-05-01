augroup MyGroup | autocmd! | augroup END
command! -nargs=* MyAutocmd autocmd MyGroup <args>

set encoding=utf-8            " エンコーディングをUTF-8に設定
set mouse=a                   " マウスを有効化
set showtabline=2             " タブを常に表示
set hidden                    " 保存せずにバッファを切り替え可能にする
set splitbelow                " :splitで画面を下に開く
set splitright                " :vsplitで画面を右に開く
set number                    " 左端に行数を表示
set signcolumn=number         " Gitの変更やLSPの警告を行数を上書きして表示
" set colorcolumn=80,100      " 80列・100列をハイライト
set cursorline                " カーソル行をハイライト
set ignorecase                " 検索時に大文字小文字の差を無視
set smartcase                 " 検索時に大文字が含まれていれば大文字小文字を区別
set inccommand=nosplit        " インクリメンタルサーチの結果をバッファ内でハイライト
set clipboard+=unnamedplus    " システムのクリップボードを使用
set expandtab                 " タブをスペースに展開
set tabstop=2                 " タブをスペース2つ相当として扱う
set shiftwidth=2              " デフォルトのインデントをスペース2つに設定
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

MyAutocmd BufEnter * setlocal formatoptions-=r " インサートモードで改行時にコメント文字を自動で追加しない
MyAutocmd BufEnter * setlocal formatoptions-=o " ノーマルモードでo/O使用時にコメント文字を自動で追加しない
MyAutocmd FileType markdown setlocal conceallevel=0 " markdownのconcealを無効化

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
let g:cache_dir = $XDG_CACHE_HOME . '/nvim'
let g:init_vim_path = g:config_dir . '/init.vim'
let g:asdf_dir = $ASDF_DATA_DIR . '/installs'
let g:node_host_prog = g:asdf_dir . '/nodejs/lts/.npm/lib/node_modules/neovim/bin/cli.js'

" デバッグ用ログ関数/コマンド
" function! Log(var) abort
"   exe 'redir >> ' g:cache_dir . '/log' | silent echo a:var | redir END
" endfunction
" command! -nargs=1 Log call Log(<args>)

" カラースキームの変更をgit管理しないように切り出している
runtime! runtime/current_colorscheme.vim
let g:colorscheme = get(g:, 'colorscheme', 'default')

runtime! runtime/dein.vim
runtime! runtime/after/*.vim
