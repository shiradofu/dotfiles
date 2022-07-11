function! plug#checkbox#setup() abort
  let g:insert_checkbox_prefix = '- '
  let g:insert_checkbox = '\<' " 文字の先頭
endfunction

function! plug#checkbox#toggle() abort
  if getline('.') =~# '^\s*$'
    let g:insert_checkbox = '$'
  endif
  ToggleCB
  let g:insert_checkbox = '\<'

  let lnum = line('.')
  let line = getline(lnum)
  call setpos('.', [0, lnum, len(line) + 1])
endfunction
