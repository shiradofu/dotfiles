nnoremap <silent> <Plug>(zz-do)     :<C-u>call user#zz#do(0)<CR>
nnoremap <silent> <Plug>(zz-should) :<C-u>call <SID>set_should_zz()<CR>

function! user#zz#do(always_upper) abort
  " after実行時、should_zzが0であれば実行しない
  if get(s:, 'should_zz', 1) == 0
    let s:should_zz = 1 | return
  endif

  let win_height = winheight(win_getid())
  let wintop_offset = getpos('.')[1] - getpos('w0')[1] + 1
  let lastline_offset = getpos('$')[1] - getpos('.')[1]  + 1
  let ideal_offset = lastline_offset ># win_height * 0.5 || a:always_upper
  \ ? float2nr(win_height * 0.25) - 1
  \ : win_height - float2nr(win_height * 0.25) - lastline_offset

  if wintop_offset ==# ideal_offset | return | endif
  if wintop_offset < ideal_offset
    exe 'normal! ' . (ideal_offset - wintop_offset) . "\<C-y>"
  endif
  if wintop_offset > ideal_offset
    exe 'normal! ' . (wintop_offset - ideal_offset) . "\<C-e>"
  endif
endfunction

function! user#zz#after(type, payload) abort
  call s:save_pos()
  if a:type ==# 'fn'
    exe 'call ' . a:payload
  elseif a:type ==# 'cmd'
    exe a:payload
  elseif a:type ==# 'map'
  echo a:type . ' ' . a:payload
    call feedkeys(a:payload, 'm')
  endif
  call feedkeys("\<Plug>(zz-should)", 'm')
  call feedkeys("\<Plug>(zz-do)", 'm')
endfunction

function! s:save_pos()
  let s:bufnr = bufnr()
  let s:lnum = getcurpos()[1]
  let s:first_line = getpos('w0')[1]
  let s:last_line = getpos('w$')[1]
endfunction

function! s:set_should_zz()
  let s:should_zz = 1
  let bufnr = bufnr()
  let lnum = getcurpos()[1]
  let first_line = getpos('w0')[1]
  let last_line = getpos('w$')[1]
  if s:bufnr !=# bufnr | return | endif
  if s:first_line !=# first_line | return | endif
  if s:last_line !=# last_line | return | endif
  " if abs(s:lnum - lnum) ># (winheight(winnr()) / 3) | return | endif
  let s:should_zz = 0
endfunction
