local z = require 'true-zen'

z.setup {
  ui = {
    bottom = {
      laststatus = 0,
      ruler = false,
      showmode = false,
      showcmd = false,
      cmdheight = 1,
    },
    top = {
      showtabline = 0,
    },
    left = {
      number = true,
      relativenumber = false,
      signcolumn = 'yes',
    },
  },
  modes = {
    ataraxis = {
      top_padding = 0,
      bottom_padding = 0,
      ideal_writing_area_width = { 120 },
      auto_padding = true,
    },
  },
  integrations = {
    gitsigns = true,
  },
  misc = {
    cursor_by_mode = true,
  },
}

local maps = { '<C-h>', '<C-j>', '<C-k>', '<C-l>', '<C-n>', '<C-p>' }
z.after_mode_ataraxis_on = function()
  for _, map in ipairs(maps) do
    vim.keymap.set('n', map, '<Nop>', { buffer = true })
  end
end

z.after_mode_ataraxis_off = function()
  for _, map in ipairs(maps) do
    vim.keymap.del('n', map, { buffer = true })
  end
end
