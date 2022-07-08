" newline.vim
" 行コメントの改行時に自動でコメント文字が挿入される挙動を調整

let s:exclude_ft = ['markdown', 'gitignore']

" インサートモードでの<CR>の挙動を調整
" 現在行がDocCommentのとき、または現在行と次行が行コメントのときは
" 新しい行の頭にコメント文字を挿入
" inoremap <expr> <CR> user#newline#cr()
function! user#newline#cr() abort
  if index(s:exclude_ft, &ft) == 0
    return "\<CR>"
  elseif !s:is_line_comment(line('.')) || s:is_comment_closed(line('.'))
    return "\<CR>"
  elseif s:is_doc_comment(line('.')) || s:is_line_comment(line('.') + 1)
    return "\<CR>"
  else
    return "\<CR>\<C-u>"
  endif
endfunction

" ノーマルモードでのoの挙動を調整
" 現在行がDocCommentのとき、または現在行と次行が行コメントのときは
" 新しい行の頭にコメント文字を挿入
function! user#newline#o() abort
  if index(s:exclude_ft, &ft) == 0
    call feedkeys("o", 'n')
  elseif !s:is_line_comment(line('.')) || s:is_comment_closed(line('.'))
    call feedkeys("o", 'n')
  elseif s:is_doc_comment(line('.')) || s:is_line_comment(line('.') + 1)
    call feedkeys("o", 'n')
  else
    call feedkeys("o\<C-u>", 'n')
  endif
endfunction

" ノーマルモードでのOの挙動を調整
" 現在行がDocCommentのとき、または現在行と前行が行コメントのときは
" 新しい行の頭にコメント文字を挿入
function! user#newline#O() abort
  if index(s:exclude_ft, &ft) == 0
    call feedkeys("O", 'n')
  elseif !s:is_line_comment(line('.')) || s:is_comment_closed(line('.'))
    call feedkeys("O", 'n')
  elseif s:is_doc_comment(line('.')) || s:is_line_comment(line('.') - 1)
    call feedkeys("O", 'n')
  else
    call feedkeys("O\<C-u>", 'n')
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

" 複数行記入可能なスタイルのコメントが1行で終わっているときを識別
" この場合はコメント行からの改行であるにも関わらず vim によりコメント
" 文字列が挿入されないので <C-u> を発動しないようにする
function! s:is_comment_closed(lnum)
  let ft = &ft
  if ft ==# 'c'
  \ || ft ==# 'cpp'
  \ || ft ==# 'php'
  \ || ft ==# 'javascript'
  \ || ft ==# 'typescript'
  \ || ft ==# 'javascriptreact'
  \ || ft ==# 'typescriptreact'
  \ || ft ==# 'java'
    let line = getline(a:lnum)
    return s:is_line_comment(a:lnum) && line =~ '\*/'
  endif
endfunction
