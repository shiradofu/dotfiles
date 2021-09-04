function plug#autopairs#hook_post_source() abort
  let g:AutoPairsMapBS = 1
  let g:AutoPairsMultilineBackspace = 1
  let g:AutoPairsCompleteOnlyOnSpace = 1
  let g:AutoPairsCenterLine = 0
  let g:AutoPairsQuotes = ["'", '"', '`']
  let g:AutoPairsMoveCharacter = ''
  let g:AutoPairsShortcutToggleMultilineClose = ''
  inoremap <silent> <C-h> <C-r>=autopairs#AutoPairsDelete()<CR>
endfunction
