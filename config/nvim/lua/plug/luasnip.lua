require('luasnip').config.setup {
  region_check_events = 'CursorMoved',
  delete_check_events = 'TextChanged',
}

require('user.mappings').luasnip()

require 'plug.luasnip.json'
