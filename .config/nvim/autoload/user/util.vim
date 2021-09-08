nnoremap <silent> <Plug>(user-set-should-zi) :<C-u>call <SID>set_should_zi()<CR>

function! user#util#zi() abort
  if get(g:, 'no_zi', 0)
    let g:no_zi = 0 | return
  endif
  let win_height = winheight(win_getid())
  let wintop_offset = getpos('.')[1] - getpos('w0')[1] + 1
  let lastline_offset = getpos('$')[1] - getpos('.')[1]  + 1
  let ideal_offset = lastline_offset ># win_height * 0.5
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

function! user#util#zi_after(cmd) abort
  call s:save_pos()
  exe a:cmd
  call feedkeys("\<Plug>(user-set-should-zi)", 'm')
  call feedkeys('zi', 'm')
endfunction

" https://koturn.hatenablog.com/entry/2018/02/12/140000
function! user#util#gotowin_or(bufname, cmd_if_not) abort
  let bnr = bufnr(a:bufname)
  if bnr == -1
    exe a:cmd_if_not
    return
  endif
  let wids = win_findbuf(bnr)
  if empty(wids)
    exe a:cmd_if_not
    return
  else
    call win_gotoid(wids[0])
  endif
endfunction

function! user#util#tabclose() abort
  exe tabpagenr('$') == 1 ? "qall" : "tabclose"
endfunction

function user#util#winmove(count)
  if a:count ==# 0
    wincmd T
  else
    call s:move_buf_to_tabpage(a:count)
  endif
endfunction

function! s:move_buf_to_tabpage(tabpagenr)
  let bufnr = bufnr() | close
  call win_gotoid(win_getid(tabpagewinnr(a:tabpagenr, '$'), a:tabpagenr))
  exe 'vert sbuffer ' . bufnr
endfunction

" windowを閉じたらwinnrを基準に1つ前のwindowに移動する
function! user#util#quit()
  if range(1, tabpagewinnr(tabpagenr(), '$')) ==# [1]
    quit | return
  endif
  let close_winnr = winnr()
  let dest_winnr = close_winnr ==# 1 ? 2 : (close_winnr - 1)
  exe dest_winnr . 'wincmd w'
  exe close_winnr . 'wincmd q'
endfunction

function! s:save_pos()
  let s:bufnr = bufnr()
  let s:lnum = getcurpos()[1]
  let s:first_line = getpos('w0')[1]
  let s:last_line = getpos('w$')[1]
endfunction

function! s:set_should_zi()
  let bufnr = bufnr()
  let lnum = getcurpos()[1]
  let first_line = getpos('w0')[1]
  let last_line = getpos('w$')[1]
  if s:bufnr !=# bufnr | return | endif
  if s:first_line !=# first_line | return | endif
  if s:last_line !=# last_line | return | endif
  " if abs(s:lnum - lnum) ># (winheight(winnr()) / 3) | return | endif
  let g:no_zi = 1
endfunction
