" https://github.com/jesseleite/vim-agriculture

call fzf#vim#_uniq([]) " autoloadを確実に読み込む(overrideするため)

function! user#rg#smart_quote_input(input)
  let hasQuotes = match(a:input, '"') > -1 || match(a:input, "'") > -1
  let hasOptions = match(' ' . a:input, '\s-[-a-zA-Z]') > -1
  let hasEscapedSpacesPlusPath = match(a:input, '\\ .*\ ') > 0
  return hasQuotes || hasOptions || hasEscapedSpacesPlusPath ? a:input : '-- "' . a:input . '"'
endfunction

function! user#rg#raw(command_suffix, no_ignore, bang) abort
  call user#sid#override_fzf_fill_quickfix()
  let command = 'rg --column --line-number --no-heading --color=always '
    \ . '--smart-case --sort path '
    \ . (a:no_ignore ? "-uu " : '')
    \ . trim(a:command_suffix)
  return fzf#vim#grep(command, 1, fzf#vim#with_preview(), a:bang)
endfunction

" substituteについて
" # は常にエスケープする
" " か ' のどちらかが含まれていない場合、含まれていない方で囲う
" " と ' が両方含まれている場合、" をエスケープして " で囲う
" " で囲う場合のみ、\ もエスケープする
function! s:escape(text) abort
  let query =  a:text
  if match(query, "'") + 1
    if match(query, '\') + 1
      let query = substitute(query, '\', '\\\\', 'g')
    endif
    if match(query, '"') + 1
      let query = '"' . substitute(query, '"', '\\"', 'g') . '"'
    else
      let query = '"' . query . '"'
    endif
  else
    let query = "'" . query . "'"
  endif
  if match(query, '#') + 1
    let query = substitute(query, '#', '\\#', 'g')
  endif
  return query
endfunction

function! user#rg#cword()  abort
  let query = expand('<cword>')
  let query = s:escape(query)
  return  query
endfunction

function! user#rg#visual(command) abort
  let query = getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]
  let query = s:escape(query)
  call feedkeys(':' . a:command . ' -F ' . query, 'i')
endfunction
