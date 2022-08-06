-- https://xbgneb0083.hatenablog.com/entry/2022_6_12_avoid_conflict_lsp_hover
-- ホバーする際に，一時的にカーソル保持でのエラー表示を無効にする

local function on_cursor_hold()
  if vim.lsp.buf.server_ready() then
    -- タイミングによってはエラーになるので抑制
    pcall(vim.diagnostic.open_float)
  end
end

local diagnostic_hover_augroup_name = 'lspconfig-diagnostic'

local function enable_diagnostics_hover()
  vim.api.nvim_create_augroup(diagnostic_hover_augroup_name, { clear = true })
  vim.api.nvim_create_autocmd(
    { 'CursorHold' },
    { group = diagnostic_hover_augroup_name, callback = on_cursor_hold }
  )
end

local function disable_diagnostics_hover()
  vim.api.nvim_clear_autocmds { group = diagnostic_hover_augroup_name }
end

vim.api.nvim_set_option('updatetime', 500)
enable_diagnostics_hover()

-- diagnosticがある行でホバーをするとすぐにdiagnosticのfloating windowで上書きされてしまうのを阻止する
-- ホバーをしたら一時的にdiagnosticを開くautocmdを無効化する
-- これだけだとそれ以降diagnosticが自動表示されなくなってしまうので有効化するautocmdを一回だけ発行して削除する
return function()
  disable_diagnostics_hover()

  vim.lsp.buf.hover()

  vim.api.nvim_create_augroup(
    'lspconfig-enable-diagnostics-hover',
    { clear = true }
  )
  -- ウィンドウの切り替えなどのイベントが絡んでくるとおかしくなるかもしれない
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = 'lspconfig-enable-diagnostics-hover',
    callback = function()
      vim.api.nvim_clear_autocmds {
        group = 'lspconfig-enable-diagnostics-hover',
      }
      enable_diagnostics_hover()
    end,
  })
end
