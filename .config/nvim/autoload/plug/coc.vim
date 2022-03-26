function! plug#coc#hook_add() abort
  set nobackup
  set nowritebackup
  set shortmess+=c

  let g:coc_disable_transparent_cursor = 1

  function! g:CocShowDocumentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  function! Format()
    silent let ret_type = type(CocAction('format'))
    if ret_type ==# 0 " format provider not found
      nunmap =
      normal ==
      nnoremap = :<C-u>call Format()<CR>
    endif
  endfunction

  function! FormatSelected()
    silent let ret_type = type(CocAction('formatSelected', visualmode()))
    if ret_type ==# 0 " format provider not found
      vunmap =
      normal gv=
      vnoremap = :<C-u>call FormatSelected()<CR>
    endif
  endfunction

  nnoremap <silent> = :<C-u>call Format()<CR>
  vnoremap <silent> = :<C-u>call FormatSelected()<CR>

  autocmd MyGroup Filetype * call s:lsp_ft(expand('<amatch>'))
  function! s:lsp_ft(ft) abort
    if !empty(a:ft) && exists('*' . 's:lsp_' . a:ft)
      execute 'call s:lsp_' . a:ft . '()'
    endif
  endfunction

  function! s:lsp_javascript() abort
    nnoremap <silent> <buffer> = :<C-u>CocCommand tsserver.organizeImports<CR>
    \ :<C-u>CocCommand prettier.formatFile<CR>
  endfunction
  let s:lsp_typescript = {-> s:lsp_javascript() }
  let s:lsp_javascriptreact = {-> s:lsp_javascript() }
  let s:lsp_typescriptreact = {-> s:lsp_javascript() }

  function! s:lsp_json() abort
    nnoremap <silent> <buffer> = :<C-u>CocCommand prettier.formatFile<CR>
  endfunction

  let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-styled-components',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-restclient',
  \ 'coc-go',
  \ '@yaegassy/coc-intelephense',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-sh',
  \ 'coc-vimlsp',
  \ 'coc-cfn-lint',
  \ 'coc-docker',
  \ 'coc-diagnostic',
  \]
endfunction
