" ] や } の展開直後にカンマを入力すると閉じカッコのあとに
" カンマを挿入する
function! plug#autopairs#comma() abort
  let cb = s:get_closing_bracket()
  if index([']', '}'], cb) != -1 && get(b:, 'bracket_cr_done', v:false)
    let lnum = line('.') + 1
    let line = getline(lnum)
    let newline = substitute(line, cb, cb.',', '')
    call setline(lnum, newline)
    let b:bracket_cr_done = v:false
  else
    call feedkeys(",", 'in')
  endif
endfunction

" 展開直後にセミコロンを入力すると閉じカッコの行の末尾に
" セミコロンを挿入する
function! plug#autopairs#semi() abort
  let cb = s:get_closing_bracket()
  if !empty(cb) && get(b:, 'bracket_cr_done', v:false)
    let lnum = line('.') + 1
    let line = getline(lnum)
    let newline = substitute(line, '$', ';', '')
    call setline(lnum, newline)
    let b:bracket_cr_done = v:false
  else
    call feedkeys(";", 'in')
  endif
endfunction

" カンマを挿入する手前のカッコを特定
function! s:get_closing_bracket() abort
  let line = getline(line('.') - 1)
  let opening_bracket = line[len(line) - 1]
  if opening_bracket ==# '{'
    return '}'
  elseif opening_bracket ==# '['
    return ']'
  elseif opening_bracket ==# '('
    return ')'
  else
    return ''
  endif
endfunction
