local M = {}

---@param regex string
function M.show_only_when_buf_matching(regex)
  return {
    show_condition = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      return bufname:find(regex) and true or false
    end,
  }
end

return M
