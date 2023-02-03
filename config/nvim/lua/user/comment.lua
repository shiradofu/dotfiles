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
---@param file_row_num number|nil
---@param col number|nil
---@return boolean
function M.is_comment(file_row_num, col)
  local captures = vim.treesitter.get_captures_at_pos(0, file_row_num, col)
  for _, cap in ipairs(captures) do
    if cap.capture == 'comment' then return true end
    if cap.capture == 'spell' then return true end
  end
  return false
end

---@param file_row_num number
---@return boolean
function M.is_line_comment(file_row_num)
  local col = get_first_non_blank_col_num(file_row_num)
  return M.is_comment(file_row_num, col)
end

---複数行スタイルのコメントかどうかを判定する
---@param file_row_num number | nil
---@return boolean
function M.is_multiline_comment(file_row_num)
  if not file_row_num then return false end
  if not M.is_line_comment(file_row_num) then return false end
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

return M
