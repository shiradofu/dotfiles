function! plug#fzf#hook_add() abort
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'border': 'sharp' } }
  let g:fzf_preview_window = ['right:50%:sharp', 'ctrl-o']

  function! s:fern_reveal(lines) abort
    vsplit
    exec 'Fern . -reveal=' . a:lines[0]
  endfunction
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-r': function('s:fern_reveal')
    \ }

  function! s:project_mru_files() abort
    let old=map(
    \ filter(extend([expand('%:p'), expand('#:p')], copy(v:oldfiles)),
    \   'v:val =~ getcwd() . "/"'
    \  . ' && filereadable(v:val)'
    \  . ' && v:val !~# ".*/\.scratch.md$"'
    \  . ' && v:val !~# ".*/\.git/index$"'
    \  . ' && v:val !~# ".*/\.git/COMMIT_EDITMSG$"'
    \ ),
    \ 'fnamemodify(v:val, ":.")'
    \ )
    let fd = split(system('fd --type f --hidden -E ".git"'))
    return fzf#vim#_uniq(old + fd)
  endfunction

  function! g:ProjectMru() abort
    call fzf#run(fzf#wrap('gfiles', fzf#vim#with_preview({
      \ 'source': s:project_mru_files(),
      \ 'options': ['--prompt', 'MRU> ']
      \ })))
  endfunction

  function! g:ProjectDirs() abort
    call fzf#run(fzf#wrap({
      \ 'source': 'fd . -t d',
      \ 'options': [
        \ '--prompt', 'Dirs> ',
        \ '--preview', 'tree -C {} | head -200 '
      \ ]
      \ }))
  endfunction

  command! -nargs=0 ProjectMru call ProjectMru()
endfunction
