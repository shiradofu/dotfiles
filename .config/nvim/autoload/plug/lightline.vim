function! plug#lightline#hook_add() abort
  augroup CocHookAdd | autocmd! | augroup END
  set noshowmode
  let g:lightline = {}
  function! LightlineCocDiagnoticsWarnings() abort
    let info = get(b:, 'coc_diagnostic_info', {})
    if empty(info) | return '' | endif
    let msgs = []
    if get(info, 'information', 0)
      call add(msgs, 'i' . info['information'])
    endif
    if get(info, 'warning', 0)
      call add(msgs, 'w' . info['warning'])
    endif
    return join(msgs, ' ')
  endfunction

  function! LightlineCocDiagnoticsErrors() abort
    let errors = get(get(b:, 'coc_diagnostic_info', {}), 'error', '')
    if empty(errors) | return '' | endif
    return 'e' . errors
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

  function! LightlineLineInfo()
    return winwidth(0) > 70 ? line('.') . ':' . col('.') : ''
  endfunction

  function! LightlineFilename()
    let path = expand('%')
    return &ft ==# 'fern' ? FernStarshipLikePath('%:t') :
          \ &ft ==# 'help' ? expand('%:t') :
          \ &ft ==# 'fugitive' ? 'Git status' :
          \ &ft ==# 'fugitiveblame' ? 'Git blame' :
          \ (path !=# '' ? path : '[No Name]')
  endfunction

  function! AsyncSetOutputDebounced(var, cmd)
    let tid = get(s:, 'tid_' . a:var, 0)
    if tid | call timer_stop(tid) | endif
    let tid = timer_start(300, {t->jobstart(
          \ a:cmd,
          \ {'on_stdout': {j,d,e-> d != [''] && execute('let s:' . a:var . ' = d')}})})
    exe 'let s:tid_' . a:var . "= " . tid
  endfunction

  function! LightlineGitBranch()
    if execute('FindRoot') ==# '' | return '' | endif
    call AsyncSetOutputDebounced('branch', 'git symbolic-ref --short HEAD')
    return ' ' . get(s:, 'branch', [''])[0]
  endfunction

  function! LightlineGitDiff(type, level)
    if execute('FindRoot') ==# '' | return '' | endif
    let var = a:type . '_' . a:level
    call AsyncSetOutputDebounced(var, 'vim-tabline-git-diff ' . a:type . ' ' . a:level)
    return get(s:, var, [''])[0]
  endfunction

  function! s:generate_lightline_git_diff()
  for type in ['Del', 'Ins', 'Files', 'AllFiles']
    let same_type_components = []
    for level in ['N', 'W', 'E']
      let funcname = 'LightlineGitDiff' . type . level
      let t = tolower(type)
      let l = tolower(level)
      let key = 'gitdiff' . t . l

      exe 'function! ' . funcname . '()' . "\n"
      \ . '  return LightlineGitDiff("' . l:t . '", "' . l:l . '")' . "\n"
      \ . 'endfunction'
      if l == 'n'
        let g:lightline.component_function[key] = funcname
      elseif l == 'w'
        let g:lightline.component_expand[key] = funcname
        let g:lightline.component_type[key] = 'warning'
      elseif l == 'e'
        let g:lightline.component_expand[key] = funcname
        let g:lightline.component_type[key] = 'error'
      endif
      call add(same_type_components, key)
    endfor
    call add(g:lightline.tabline.right, same_type_components)
    let same_type_components = []
  endfor
  endfunction

  function! LightlineTabname(tabnr) abort
    let buflist = tabpagebuflist(a:tabnr)
    let first_bufnr = buflist[0]
    let first_fpath = expand('#' . first_bufnr . ':p')
    let focused_bufnr = buflist[tabpagewinnr(a:tabnr) - 1]
    let focused_fpath = expand('#' . focused_bufnr . ':p')
    let focused_fname = expand('#' . focused_bufnr . ':t')
    return
    \ first_fpath   =~ '\.git\/index' ? 'Git status' :
    \ focused_fpath =~ '^fern:\/\/'   ? FernStarshipLikePath(focused_fname) . '/' :
    \ focused_fname =~ ';#FZF'        ? 'FZF' :
    \ ('' != focused_fname ? focused_fname : '[No Name]')
  endfunction

  let g:lightline = {
  \ 'active': {
  \   'right': [ [ 'cocerrors', 'cocwarnings', ],
  \              [],
  \              [ 'lineinfo' ,'fileformat', 'fileencoding', 'filetype' ] ],
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified' ] ] },
  \'inactive': {
  \   'left': [ [ 'filename' ] ],
  \   'right': [] },
  \ 'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [ [ 'gitbranch' ], [],
  \               ] },
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \   'fileformat': 'LightlineFileformat',
  \   'filetype': 'LightlineFiletype',
  \   'fileencoding': 'LightlineFileencoding',
  \   'lineinfo': 'LightlineLineInfo',
  \   'gitbranch': 'LightlineGitBranch',
  \ },
  \ 'component_expand': {
  \   'cocwarnings': 'LightlineCocDiagnoticsWarnings',
  \   'cocerrors': 'LightlineCocDiagnoticsErrors',
  \ },
  \ 'component_type': {
  \   'cocwarnings': 'warning',
  \   'cocerrors': 'error',
  \ },
  \ 'mode_map': {
  \   'n' : 'n',
  \   'i' : 'i',
  \   'R' : 'r',
  \   'v' : 'v',
  \   'V' : 'V',
  \   "\<C-v>": 'Λ',
  \   'c' : 'c',
  \   's' : 's',
  \   'S' : 'S',
  \   "\<C-s>": '§',
  \   't': 't',
  \ },
  \ 'tab_component_function': {
  \   'filename': 'LightlineTabname',
  \ },
  \ }

  call s:generate_lightline_git_diff()
  autocmd CocHookAdd User CocStatusChange,CocDiagnosticChange call lightline#update()
endfunction
