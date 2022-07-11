require("luasnip").config.setup {
  region_check_events = "CursorMoved",
  delete_check_events = "TextChanged",
}

vim.cmd [[imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']]
vim.cmd [[inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<CR>]]
vim.cmd [[snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>]]
vim.cmd [[snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>]]
