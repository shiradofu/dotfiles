function! plug#print_debug#config() abort
  call extend(get(g:, 'print_debug_templates', {}), {
  \  'sh':  'echo "+++ {}"',
  \  'zsh': 'echo "+++ {}"',
  \  'go': 'fmt.Println("+++ {}")',
  \  'php': "logger('+++ {}');",
  \  'lua': "print '+++ {}'",
  \  'vim': "echo '+++ {}'",
  \ })
endfunction
