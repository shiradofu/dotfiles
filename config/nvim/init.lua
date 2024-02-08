-- stylua: ignore start
vim.opt.fileformat  = 'unix'
vim.opt.encoding    = 'utf-8'
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 2
vim.opt.expandtab   = true
vim.opt.smartindent = true      -- C言語風のプログラミング言語向けの自動インデント
vim.opt.shiftround  = true      -- インデントをshiftwidthの整数倍に揃える
vim.opt.fo:append     'ro'      -- 行コメント改行時にコメント文字を自動挿入
vim.opt.ignorecase  = true      -- 検索時に大文字小文字の差を無視
vim.opt.smartcase   = true      -- 検索時に大文字が含まれていれば大文字小文字を区別
vim.opt.inccommand  = 'nosplit' -- インクリメンタルサーチの結果をハイライト
vim.opt.swapfile    = false     -- スワップファイルを無効化
vim.opt.hidden      = true      -- 保存せずにバッファを切り替え可能にする
vim.opt.splitbelow  = true      -- :splitで画面を下に開く
vim.opt.splitright  = true      -- :vsplitで画面を右に開く

vim.opt.number        = true
vim.opt.signcolumn    = 'number'
vim.opt.cursorline    = true
vim.opt.showtabline   = 1    -- タブが複数ある場合はタブを表示
vim.opt.laststatus    = 2    -- statusline を常に表示
vim.opt.termguicolors = true -- TUIで24bitカラーを有効にする
-- ステータスライン・バッファの終わりを埋める文字を空白化
vim.opt.fillchars = { vert = ' ', eob = ' ' }
-- コマンドモードのカーソルをビーム形状に(vertical, width 10%)
vim.opt.guicursor:append { c = 'ver10' }

vim.opt.updatetime = 500
vim.opt.ttimeoutlen = 5                -- キーの確定待ちまでの時間
vim.opt.clipboard:append 'unnamedplus' -- システムのクリップボードを使用
vim.opt.mouse = 'a'                    -- マウスを有効化
vim.opt.shada:append [['10000]]        -- 編集したファイルを10000件記憶
vim.opt.shada:remove [['100]]          -- 編集したファイル記憶数のデフォルトを除去
vim.opt.diffopt = {
  'internal',
  'filler',
  'indent-heuristic',
  algorithm = 'histogram'
}
vim.opt.fileencodings = {
  'utf-8',
  'cp932',
  'euc-jp',
  'iso-20220-jp',
  'default',
  'latin'
}

-- ターミナルでのヤンク時文字化け回避
-- https://github.com/neovim/neovim/issues/5683#issuecomment-420833679
-- vim.cmd.lang 'en_US.UTF-8'

-- 不要な機能の無効化
-- https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
vim.g.loaded_gzip              = 1
vim.g.loaded_tar               = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_zip               = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_vimball           = 1
vim.g.loaded_vimballPlugin     = 1
vim.g.loaded_getscript         = 1
vim.g.loaded_getscriptPlugin   = 1
vim.g.loaded_netrwPlugin       = 1
vim.g.loaded_netrwSettings     = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_node_provider     = 0
vim.g.loaded_ruby_provider     = 0
vim.g.loaded_perl_provider     = 0
vim.g.loaded_python3_provider  = 0
vim.g.vim_json_conceal         = 0
vim.g.vim_markdown_conceal     = 0

require 'user'
require 'user.filetype'
require 'user.mappings'
require 'user.colorscheme'

LAZY_DIR = vim.fn.stdpath 'data' .. '/lazy'
local lazy_path = LAZY_DIR .. '/lazy.nvim'
vim.opt.rtp:prepend(lazy_path)
require('lazy').setup(
  { { import = 'plug' }, { import = 'plug.dev' }, },
  {
    defaults = { lazy = true },
    dev = { path = vim.env.MY_REPOS },
    change_detection = {
      enabled = false,
      notify = false,
    },
  }
)
