vim.filetype.add {
  extension = {
    example = 'sh',
  },
  filename = {
    ['.env'] = 'sh',
    ['phpstan.neon.dist'] = 'yaml',
    ['Brewfile'] = 'ruby',
  },
  pattern = {
    ['.env.*'] = 'sh',
  },
}

-- Golang
-- インデント設定
local go = vim.api.nvim_create_augroup('FtGolang', {})
vim.api.nvim_create_autocmd('FileType', {
  group = go,
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})

-- Markdown
-- チェックボックスのハイライト
local md = vim.api.nvim_create_augroup('FtMarkdown', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = md,
  pattern = '*.md',
  callback = function()
    vim.cmd [[
      syntax match MdCheckedItem containedin=ALL '\v\s*(-\s+)?\[x\]\s+.*'
      hi link MdCheckedItem Comment
    ]]
  end,
})

-- QuickFix
-- 常に下に表示する
-- サイズは最小5行、最大画面の高さの2割
local qf = vim.api.nvim_create_augroup('FtQuickfix', {})
vim.api.nvim_create_autocmd('FileType', {
  group = qf,
  pattern = 'qf',
  callback = function()
    vim.cmd.wincmd 'J'
    local min_height = 5
    local max_height = math.floor(vim.o.lines * 0.2)
    local item_num = #vim.fn.getqflist()
    local height = min_height
    if item_num + 1 > min_height then height = item_num + 1 end
    if max_height > min_height and height > max_height then
      height = max_height
    end
    vim.api.nvim_win_set_height(0, height)
  end,
})
