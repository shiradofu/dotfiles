function! plug#gitgutter#hook_add() abort
  let g:gitgutter_map_keys = 0
  let g:gitgutter_sign_added = '‖'
  let g:gitgutter_sign_modified = '‖'
  let g:gitgutter_sign_removed = '‖'
  let g:gitgutter_sign_modified_removed = '‖'
  let g:gitgutter_sign_removed_first_line = '‖'
  let g:gitgutter_terminal_reports_focus = 0
endfunction
