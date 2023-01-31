local util = require 'user.util'
local comment = require 'user.comment'

local M = {}

local function is_comment_string_added(file_row_num)
  local first_char_col = util.get_line_content(file_row_num):find '%S'
  if first_char_col == nil then return false end
  local cur_col = vim.api.nvim_win_get_cursor(0)[2]
  return not (first_char_col == cur_col + 1)
end

---o または <CR> での改行後に実行。
---改行後、カーソル行にコメントが挿入されている場合、
---カーソル行のもう一つ次の行もコメントである(カーソル行が行コメントに挟まれている)、
---または改行前の行が複数行スタイルのコメント内部である場合を除き、
---改行後に挿入されるコメント文字を削除する。
function M.next()
  local n = util.file_row_num.cursor()
  if
    is_comment_string_added(n)
    and not comment.is_line_comment(n + 1)
    and not comment.is_multiline_comment(n - 1)
  then
    util.feedkeys('<C-u>', 'n')
  end
end

---O での改行後に実行。
---改行後、カーソル行にコメントが挿入されている場合、
---カーソル行のもう一つ前の行もコメントである(カーソル行が行コメントに挟まれている)、
---または改行前の行が複数行スタイルのコメント内部である場合を除き、
---改行後に挿入されるコメント文字を削除する。
function M.prev()
  local n = util.file_row_num.cursor()
  if
    is_comment_string_added(n)
    and not comment.is_line_comment(n - 1)
    and not comment.is_multiline_comment(n + 1)
  then
    util.feedkeys('<C-u>', 'n')
  end
end

return M
