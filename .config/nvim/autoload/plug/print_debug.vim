function! plug#print_debug#config() abort
  let g:print_debug_templates += {
  \  'sh':  'echo "+++ {}"',
  \  'zsh': 'echo "+++ {}"',
  \  'php': 'logger("+++ {}")',
  \  'lua': 'print("+++ {}")',
  \  'vim': 'echo "+++ {}"',
  \ }
endfunction
