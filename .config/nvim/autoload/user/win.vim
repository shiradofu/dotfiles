" https://koturn.hatenablog.com/entry/2018/02/12/140000
function! user#win#goto_or(bufname, cmd_if_not) abort
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

function user#win#move(count)
  if a:count ==# 0
    wincmd T
  else
    call s:move_buf_to_tabpage(a:count)
  endif
endfunction

" windowを指定したタブに移動する
function! s:move_buf_to_tabpage(tabpagenr)
  let bufnr = bufnr() | close
  call win_gotoid(win_getid(tabpagewinnr(a:tabpagenr, '$'), a:tabpagenr))
  exe 'vert sbuffer ' . bufnr
endfunction

" windowを閉じたらwinnrを基準に1つ前のwindowに移動する
function! user#win#quit()
  if range(1, tabpagewinnr(tabpagenr(), '$')) ==# [1]
    quit | return
  endif
  let close_winnr = winnr()
  let dest_winnr = close_winnr ==# 1 ? 2 : (close_winnr - 1)
  exe dest_winnr . 'wincmd w'
  try
    exe close_winnr . 'wincmd q'
  catch /^Vim\%((\a\+)\)\=:E5601/
    " タブ内にwindow1つ+floating windowが表示されているとき
    call user#win#tabclose()
  endtry
endfunction

function! user#win#tabclose() abort
  exe tabpagenr('$') == 1 ? "qall" : "tabclose"
endfunction
