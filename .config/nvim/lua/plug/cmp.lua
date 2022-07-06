local cmp = require "cmp"

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-j>"] = cmp.mapping.scroll_docs(-4),
    ["<C-k>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-c>"] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false`
    -- to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping.confirm { select = true },
    ["<CR>"] = cmp.mapping.confirm { select = false },
  },
  -- nvim_lsp と luasnip の候補があるうちは buffer の候補は表示しない
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
}

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "cmdline" },
    { name = "path" },
  },
})
