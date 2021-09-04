function! plug#fugitive#hook_add() abort
  let g:fugitive_no_maps = 1
  let g:nremap = {"gs": "<Nop>", "a": "<Nop>", "n": "<Nop>"}
endfunction

function! plug#fugitive#hook_post_source() abort
  function! FugitiveStageDiffPreview(files, t)
    if getline(line('.')) !~# '^[MRDA?] .\+[^/]$' | return | endif
    let b:fugitive_files = a:files
    call FugitiveStageDiff()
    wincmd w
  endfunction

  function! AsyncStageDiffPreviewDebounced()
    let tid = get(s:, 'tid_fugitive_diff', 0)
    if tid | call timer_stop(tid) | endif
    let s:tid_fugitive_diff = timer_start(
      \ 250,
      \ function('FugitiveStageDiffPreview', [get(b:, 'fugitive_files', {})])
      \)
  endfunction

  function! FugitiveStatusOperation(operation)
    if a:operation ==# 'j'
      call FugitiveNextItem()
    elseif a:operation ==# 'k'
      call FugitivePreviousItem()
      call cursor(getpos('.')[1], 1)
    elseif a:operation ==# 'h'
      call FugitivePreviousSection()
    elseif a:operation ==# 'l'
      call FugitiveNextSection()
    elseif a:operation ==# 'nToggle'
      call FugitiveToggleStagedNormal()
    elseif a:operation ==# 'vToggle'
      call FugitiveToggleStagedVisual()
    endif
    call AsyncStageDiffPreviewDebounced()
  endfunction

  function! InitFugitiveGitStatus() abort
    call user#sid#globalize_fugitive_functions()
    nnoremap <silent> <buffer> j :<C-u>call FugitiveStatusOperation('j')<CR>
    nnoremap <silent> <buffer> k :<C-u>call FugitiveStatusOperation('k')<CR>
    nnoremap <silent> <buffer> h :<C-u>call FugitiveStatusOperation('h')<CR>
    nnoremap <silent> <buffer> l :<C-u>call FugitiveStatusOperation('l')<CR>
    nnoremap <silent> <buffer> a :<C-u>call FugitiveStatusOperation('nToggle')<CR>
    nnoremap <silent> <buffer> s :<C-u>call FugitiveStatusOperation('nToggle')<CR>
    vnoremap <silent> <buffer> a :<C-u>call FugitiveStatusOperation('vToggle')<CR>
    vnoremap <silent> <buffer> s :<C-u>call FugitiveStatusOperation('vToggle')<CR>
    nnoremap <buffer> <C-j> <C-w>W
  endfunction
  MyAutocmd FileType fugitive call InitFugitiveGitStatus()
endfunction
