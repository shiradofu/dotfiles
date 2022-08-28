local U = {}

function U.feedkeys(key, mode)
  key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(key, mode, false)
end

U.js_family =
  { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

U.fzf_fd_noignore =
  '--color=never --type f --hidden --follow --exclude .git --no-ignore-vcs'
U.fzf_rg_noignore =
  '--column --line-number --no-heading --color=always --smart-case --max-columns=512 --no-ignore-vcs'

return U
