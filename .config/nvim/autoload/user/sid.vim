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

