" newline.vim
" 行コメントの改行時に自動でコメント文字が挿入される挙動を調整

let s:exclude_ft = ['markdown', 'gitignore']

" o または <CR> での改行後に実行
" 前行がDocCommentのとき、または次行も行コメントのとき以外は
" 改行後に挿入されるコメント文字を削除
function! user#newline#n() abort
  if getline(line('.')) =~# '^\s*$' | return | endif
  if index(s:exclude_ft, &ft) == -1
    \ && s:is_line_comment(line('.'))
    \ && !s:is_line_comment(line('.') + 1)
    \ && !s:is_doc_comment(line('.') - 1)
    call feedkeys("\<C-u>", 'in')
  endif
endfunction

" O での改行後に実行
" 次行がDocCommentのとき、または前行も行コメントのとき以外は
" 改行後に挿入されるコメント文字を削除
function! user#newline#p() abort
  if getline(line('.')) =~# '^\s*$' | return | endif
  if index(s:exclude_ft, &ft) == -1
    \ && s:is_line_comment(line('.'))
    \ && !s:is_line_comment(line('.') - 1)
    \ && !s:is_doc_comment(line('.') + 1)
    call feedkeys("\<C-u>", 'in')
  endif
endfunction

" 指定した番号の行が行コメントかどうか判定
" 行の空白文字以外の最初の文字のシンタックスハイライトグループ名を確認
" 最初の文字が Comment であれば行コメントと判定する
function! s:is_line_comment(lnum)
  let first_char =  match(getline(a:lnum),'\S') + 1
  let syn = synIDattr(synIDtrans(synID(a:lnum, first_char, 1)), 'name')
  return syn ==# 'Comment'
endfunction

" 指定した番号の行がドキュメンテーションコメントかどうか判定
" 行の空白文字以外の最初の文字のシンタックスハイライト詳細名を確認
" 最初の文字が HogeDocComment、または行が /** のみであればドキュメンテーションと判定する
function! s:is_doc_comment(lnum)
  let line = getline(a:lnum)
  " 行の空白文字以外の最初の文字位置
  let first_char =  match(line,'\S') + 1
  " 最初の文字のシンタックスハイライトの詳細名
  let syn = synIDattr(synID(a:lnum, first_char, 1), 'name')
  if syn =~ '.*DocComment' | return 1 | endif

  " filetypeによるドキュメンテーションコメントのチェック
  let ft = &ft
  if ft ==# 'php'
  \ || ft ==# 'javascript'
  \ || ft ==# 'typescript'
  \ || ft ==# 'javascriptreact'
  \ || ft ==# 'typescriptreact'
  \ || ft ==# 'java'
    return s:is_line_comment(a:lnum) &&
    \ line =~ '^\s*/\*\*\?\s*' || line =~ '^\s*\*\s*'
  endif
endfunction
