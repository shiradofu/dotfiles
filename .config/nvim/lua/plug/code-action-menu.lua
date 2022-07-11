local c = require "code_action_menu"

-- overwrite builtin function
vim.lsp.buf.code_action = c.open_code_action_menu

local g = vim.api.nvim_create_augroup("MyCodeActionMenu", {})
vim.api.nvim_clear_autocmds { group = g }
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "code-action-menu-menu",
  group = g,
  callback = function()
    vim.keymap.set(
      "n",
      "<BS>",
      c.close_code_action_menu,
      { noremap = true, silent = true, buffer = true }
    )
  end,
})
