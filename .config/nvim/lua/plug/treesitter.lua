local function ts_disable(_, bufnr)
	return vim.api.nvim_buf_line_count(bufnr) > 5000
end

require'nvim-treesitter.configs'.setup {
	ensure_installed = 'all',
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {
      'vim',
      'markdown',
    },
  },
}

local augroup = vim.api.nvim_create_augroup('MyTreesitter', {})
vim.api.nvim_create_autocmd('Syntax', {
	pattern = 'markdown',
  callback = function()
    vim.cmd[[syntax on]]
    vim.cmd[[syntax match checkedItem containedin=ALL "\v\s*(-\s+)?\[x\]\s+.*"]]
  end,
	group = augroup,
})
