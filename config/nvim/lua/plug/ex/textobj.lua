local util = require 'user.util'
local comment = require 'user.comment'

local M = {}

function M.linewise_bracket(opening, closing)
  local cur = vim.api.nvim_win_get_cursor(0)
  local row = cur[1] - 1
  local col = cur[2]
  local char = util.get_line_content(row):sub(col + 1, col + 1)
  local flags = char == closing and 'cW' or 'W'

  vim.fn.searchpair(opening, '', closing, flags)
  local closing_pos = vim.fn.getpos '.'
  vim.cmd 'normal! %'
  local opening_pos = vim.fn.getpos '.'
  return { 'V', opening_pos, closing_pos }
end

local function check_comment_chunk()
  local n = util.file_row_num.cursor()
  local l = util.get_line_content(n)
  return comment.is_line_comment(n) or l:find '^%s*$'
end

function M.comment_chunk()
  local start_pos, end_pos
  if not check_comment_chunk() then return 0 end
  for i = 1, 1000 do
    vim.cmd 'normal! k'
    if not check_comment_chunk() then
      vim.cmd 'normal! j'
      start_pos = vim.fn.getpos '.'
      vim.cmd('normal! ' .. i .. 'jk')
      break
    end
  end
  for _ = 1, 1000 do
    vim.cmd 'normal! j'
    if not check_comment_chunk() then
      vim.cmd 'normal! k'
      end_pos = vim.fn.getpos '.'
    end
  end
  return { 'V', start_pos, end_pos }
end

return M
