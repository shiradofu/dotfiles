local ls = require "luasnip"

vim.cmd [[imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']]
vim.cmd [[inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<CR>]]
vim.cmd [[snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>]]
vim.cmd [[snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>]]
