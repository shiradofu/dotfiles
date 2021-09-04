function! plug#vista#hook_add() abort
  let g:vista_default_executive = 'coc'
  let g:vista#renderer#enable_icon = 0
  let g:vista_echo_cursor = 0
  let g:vista_sidebar_position = 'vertical belowright'
  let g:vista_blink = [1, 100]
  " let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
  " let g:vista#renderer#icons = {
  " \  'function': '\uea94',
  " \  'method': '#',
  " \  'variable': '\uea1b',
  " \  'variables': '\uea1b',
  " \  }
endfunction
