UsePlugin 'vim-auto-save'

let g:auto_save = 1
let g:auto_save_silent = 1

" git管理下にあるファイルでのみ有効化
" ref: https://utgwkk.hateblo.jp/entry/2017/03/24/163730
function! g:GitOrNot()
  if !exists("*fugitive#head") || "" == fugitive#head()
    return 0
  endif
  let s:git_ls = systemlist('git ls-tree -r master --name-only')
  return match(s:git_ls, expand("%")) + 1
endfunction
autocmd myAu BufEnter * let b:auto_save = g:GitOrNot()
autocmd myAu FileType gitcommit let b:auto_save = 0
