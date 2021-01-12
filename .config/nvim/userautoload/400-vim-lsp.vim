UsePlugin 'vim-lsp'

let g:lsp_settings = {
\  'efm-langserver': {'disabled': v:false}
\}

let g:lsp_documentation_debounce = 80 " default: 80
let g:lsp_diagnostics_echo_delay = 0 " default: 500
let g:lsp_diagnostics_float_cursor = 0 " default: 0
let g:lsp_diagnostics_float_delay = 200 " default: 500
let g:lsp_virtual_text_prefix = "  🍖 "
let g:lsp_document_highlight_delay = 200 " default: 350

au myAu ColorScheme *
\ highlight LspErrorVirtual       ctermfg=245 ctermbg=none |
\ highlight LspWarningVirtual     ctermfg=245 ctermbg=none |
\ highlight LspInformationVirtual ctermfg=245 ctermbg=none |
\ highlight LspHintVirtual        ctermfg=245 ctermbg=none
"\ highlight LspErrorHighlight
"\ highlight LspWarningHighlight
"\ highlight LspInformationHighlight
"\ highlight LspHintHighlight

au myAu ColorScheme * highlight PopupWindow ctermbg=016 ctermfg=255
au myAu ColorScheme * highlight Pmenu ctermbg=016 ctermfg=255

let g:lsp_log_file = expand('~/.config/nvim/lsp.log')

" サーバを指定したフォーマットのコマンド
" 複数の言語サーバがある場合、vim-lspはそのうち最初のものを自動で選ぶ
" https://github.com/prabirshrestha/vim-lsp/blob/5c91c59f2ab84f2825c0e23a1b7053e3891a34fc/autoload/lsp/internal/document_formatting.vim#L24-L25
function! LspDocumentFormatWithSpecificServer()
  if index([
\   'javascript',
\   'javascript.jsx',
\   'javascriptreact',
\   'typescript',
\   'typescript.tsx',
\   'typescriptreact'
\ ], &filetype) != -1
    call lsp#internal#document_formatting#format({ 'bufnr': bufnr('%'), 'server': 'efm-langserver' })
  endif
endfunction
command! LspDocumentFormatWithSpecificServer call LspDocumentFormatWithSpecificServer()
