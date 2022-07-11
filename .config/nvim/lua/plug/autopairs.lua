require("nvim-autopairs").setup {
  map_c_h = true,
  map_c_w = true,
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"

local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
