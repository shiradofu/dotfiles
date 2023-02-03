local feedkeys = require('user.util').feedkeys
function add_char_after_closing_bracket_completed_by_cr(char)
  if vim.b.bracket_cr_done then
    -- n is the absolute row number of the next row (0-base)
    local n = vim.api.nvim_win_get_cursor(0)[1]
    local next_line_content =
      vim.api.nvim_buf_get_lines(0, n, n + 1, false)[1]
    if next_line_content then
      vim.api.nvim_buf_set_lines(
        0,
        n,
        n + 1,
        true,
        { next_line_content .. char }
      )
    end
  else
    feedkeys(char, 'in')
  end
end

local M = {}
function M.semicolon() add_char_after_closing_bracket_completed_by_cr ';' end
function M.comma() add_char_after_closing_bracket_completed_by_cr ',' end

return M
