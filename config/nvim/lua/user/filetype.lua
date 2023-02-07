vim.filetype.add {
  extension = {
    example = 'sh',
  },
  filename = {
    ['.env'] = 'sh',
    ['phpstan.neon.dist'] = 'yaml',
    ['Brewfile'] = 'ruby',
  },
  pattern = {
    ['.env.*'] = 'sh',
  },
}
