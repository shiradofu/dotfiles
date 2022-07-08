local t = require("user/utils").table
local M = {}

local k = vim.keymap.set
local o = { noremap = true, silent = true }
local bo = t.merge(o, { buffer = true })

M.diagnostic = function()
  k("n", "[e", vim.diagnostic.goto_prev, o)
  k("n", "]e", vim.diagnostic.goto_next, o)
end

M.jump = function()
  k("n", "gd", vim.lsp.buf.definition, bo)
  k("n", "gD", "<cmd>vs|lua vim.lsp.buf.definition()<CR>", bo)
  k("n", "<leader>n", vim.lsp.buf.references, bo)
end

M.hover = function()
  k("n", "K", vim.lsp.buf.hover, bo)
end

M.rename = function()
  k("n", "gr", vim.lsp.buf.rename, bo)
end

M.action = function()
  k("n", "ga", vim.lsp.buf.code_action, bo)
end

M.format = function(fn)
  k("n", "=", fn, bo)
end

return M
