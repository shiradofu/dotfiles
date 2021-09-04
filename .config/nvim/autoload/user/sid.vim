" s:scripts is array of ['sid', 'scrip path']
function! s:get_scriptnames() abort
  let scripts = split(execute('scriptnames'), "\n")
  let s:scripts = map(copy(scripts), 'split(v:val, "\\v:=\\s+")')
endfunction

function! user#sid#get_script_id(name, ...) abort
  let last_change = get(a:, 1, 0)
  if last_change || !exists('s:scripts')
    call s:get_scriptnames()
  endif
  let matches = filter(copy(s:scripts), 'v:val[1] =~ a:name')
  if len(matches) > 1
    throw "Too many scripts match `".a:name."`: ".string(matches)
  elseif empty(matches)
    if last_change
      throw "No script match `".a:name."`"
    else
      return user#sid#get_script_id(a:name, 1)
    endif
  endif
  return matches[0][0]
endfunction

function! user#sid#globalize_commentary_textobj() abort
  if !exists('s:commentary_id')
    let s:commentary_id = user#sid#get_script_id('\/commentary\.vim')
    call execute([
      \ 'function! CommentaryTextobj() abort',
      \   'call <SNR>' . s:commentary_id . "_textobject(get(v:, 'operator', '') ==# 'c')",
      \ 'endfunction',
      \ ])
  endif
endfunction

function! user#sid#globalize_fugitive_functions() abort
  if !exists('s:fugitive_id')
    let s:fugitive_id = user#sid#get_script_id('autoload\/fugitive\.vim')
    call execute([
      \ 'function! FugitiveStageDiff() abort',
      \   'exe <SNR>' . s:fugitive_id . '_StageDiff("Gdiffsplit")',
      \ 'endfunction',
      \ 'function! FugitiveNextItem() abort',
      \   'call <SNR>' . s:fugitive_id . '_NextItem(v:count1)',
      \ 'endfunction',
      \ 'function! FugitivePreviousItem() abort',
      \   'call <SNR>' . s:fugitive_id . '_PreviousItem(v:count1)',
      \ 'endfunction',
      \ 'function! FugitiveNextSection() abort',
      \   'exe <SNR>' . s:fugitive_id . '_NextSection(v:count1)',
      \ 'endfunction',
      \ 'function! FugitivePreviousSection() abort',
      \   'exe <SNR>' . s:fugitive_id . '_PreviousSection(v:count1)',
      \ 'endfunction',
      \ 'function! FugitiveToggleStagedNormal() abort',
      \   'exe <SNR>' . s:fugitive_id . '_Do("Toggle",0)',
      \ 'endfunction',
      \ 'function! FugitiveToggleStagedVisual() abort',
      \   'exe <SNR>' . s:fugitive_id . '_Do("Toggle",1)',
      \ 'endfunction',
      \ ])
  endif
endfunction

function! user#sid#override_fzf_fill_quickfix() abort
  if !exists('s:fzf_vim_id')
    let s:fzf_vim_id = user#sid#get_script_id('fzf\/vim\.vim')
    call execute([
      \ 'function! <SNR>' . s:fzf_vim_id . '_fill_quickfix(list, ...)',
      \   'if len(a:list) > 1',
      \     'call setqflist(a:list)',
      \     'botright copen',
      \   'endif',
      \ 'endfunction'
      \ ])
  endif
endfunction

