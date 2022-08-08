require('project-note').setup {
  note_dir = '/Users/kinugoshi/workspace/a',
  note_path = function(root)
    return root:sub(#'/Users/kinugoshi/.ghq/github.com/') .. '.md'
  end,
  auto_push = true,
}
