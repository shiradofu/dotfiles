local util = require 'user.util'

local M = {}

---@param file_row_num number | nil
---@return number | nil
local function get_first_non_blank_col_num(file_row_num)
  if not file_row_num then return nil end
  local col = util.get_line_content(file_row_num):find '%S'
  if not col then return nil end
  return col - 1
end

---与えられた位置の文字のキャプチャがコメントかどうかを判定
---@param file_row_num number | nil
---@param col number | nil
---@return boolean
local function is_comment(file_row_num, col)
  local captures = vim.treesitter.get_captures_at_pos(0, file_row_num, col)
  for _, cap in ipairs(captures) do
    if cap.capture == 'comment' then return true end
    if cap.capture == 'spell' then return true end
  end
  return false
end

---@param file_row_num number
---@return boolean
local function is_line_comment(file_row_num)
  local col = get_first_non_blank_col_num(file_row_num)
  return is_comment(file_row_num, col)
end

---複数行スタイルのコメントかどうかを判定する
---@param file_row_num number | nil
---@return boolean
local function is_multiline_comment(file_row_num)
  if not file_row_num then return false end
  if not is_line_comment(file_row_num) then return false end
  local ft = vim.bo.ft
  -- filetypeによるドキュメンテーションコメントのチェック
  if
    vim.tbl_contains({
      'c',
      'cpp',
      'php',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'java',
    }, ft)
  then
    local line = util.get_line_content(file_row_num)
    if line:find '^%s*/%*%*?%s*' or line:find '^%s*%*%s*' then return true end
  end
  return false
end

---o または <CR> での改行後に実行。
---改行後、カーソル行にコメントが挿入されている場合、
---カーソル行のもう一つ次の行もコメントである(カーソル行が行コメントに挟まれている)、
---または改行前の行が複数行スタイルのコメント内部である場合を除き、
---改行後に挿入されるコメント文字を削除する。
function M.next()
  local n = util.file_row_num.cursor()
  if util.get_line_content(n):find '^%s*$' then return end
  if not is_line_comment(n + 1) and not is_multiline_comment(n - 1) then
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
  if util.get_line_content(n):find '^%s*$' then return end
  if not is_line_comment(n - 1) and not is_multiline_comment(n + 1) then
    util.feedkeys('<C-u>', 'n')
  end
end

return M
