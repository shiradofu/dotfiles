function! plug#markdown#setup() abort
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_conceal_code_blocks = 1
  let g:vim_markdown_no_default_key_mappings = 1
  let g:vim_markdown_new_list_item_indent = 0
  let g:vim_markdown_auto_insert_bullets = 0

  let g:vim_markdown_fenced_languages = [
  \ 'viml=vim',
  \ 'bash=sh',
  \ 'html=html',
  \ 'css=css',
  \ 'js=javascriptreact',
  \ 'ts=typescriptreact',
  \ 'php=php',
  \ 'go=go',
  \ ]
endfunction
