return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'lukas-reineke/cmp-rg',
    'lukas-reineke/cmp-under-comparator',
  },
  config = function()
    local cmp = require 'cmp'
    local maps = require('user.mappings').cmp_selection(cmp)
    local lspkind = require 'lspkind'
    local compare = cmp.config.compare

    cmp.setup {
      -- completion = { autocomplete = false },
      snippet = { expand = function(args) vim.snippet.expand(args.body) end },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
        ['<Tab>'] = { i = maps['<Tab>'] },
        ['<C-n>'] = { i = maps['<C-n>'] },
        ['<C-p>'] = { i = maps['<C-p>'] },
        ['<C-l>'] = { i = maps['<C-l>'] },
      },
      preselect = cmp.PreselectMode.None,
      view = {
        entries = {
          name = 'custom',
          selection_order = 'near_cursor',
        },
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol',
          show_labelDetails = true,
          menu = {
            nvim_lsp = '[LSP]',
            buffer = '[Buf]',
            rg = '[Rg]',
          },
        },
      },
      experimental = { ghost_text = false },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        {
          name = 'buffer',
          option = {
            -- https://github.com/hrsh7th/cmp-buffer#performance-on-large-text-files
            get_bufnrs = function()
              local bufs = {}
              local all = vim.api.nvim_list_bufs()
              for _, buf in ipairs(all) do
                local byte_size = vim.api.nvim_buf_get_offset(
                  buf,
                  vim.api.nvim_buf_line_count(buf)
                )
                if byte_size <= 1024 * 1024 then -- 1 Megabyte max
                  bufs[#bufs + 1] = buf
                end
              end
              return bufs
            end,
          },
        },
        { name = 'path' },
        {
          name = 'rg',
          max_item_count = 5,
          option = {
            additional_arguments = "-g '!*.svg'"
              .. " -g '!composer.lock'"
              .. " -g '!package-lock.json'"
              .. " -g '!yarn.lock'",
          },
        },
      },
    }

    cmp.setup.cmdline('/', {
      mapping = {
        ['<Tab>'] = { c = maps['<Tab>'] },
        ['<C-n>'] = { c = maps['<C-n>'] },
        ['<C-p>'] = { c = maps['<C-p>'] },
        ['<C-l>'] = { c = maps['<C-l>'] },
      },
      sources = cmp.config.sources {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = {
        ['<Tab>'] = { c = maps['<Tab>'] },
        ['<C-n>'] = { c = maps['<C-n>'] },
        ['<C-p>'] = { c = maps['<C-p>'] },
        ['<C-l>'] = { c = maps['<C-l>'] },
      },
      sources = cmp.config.sources {
        { name = 'cmdline' },
        { name = 'path' },
      },
    })

    cmp.setup.filetype('rust', {
      sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          compare.scopes,
          compare.score,
          compare.recently_used,
          require('cmp-under-comparator').under,
          compare.kind,
          compare.locality,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      },
      snippet = {
        expand = function(args)
          args.body = args.body:gsub('…(.*)$', '$0%1')
          vim.snippet.expand(args.body)
        end,
      },
    })
  end,
}
