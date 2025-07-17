return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '│',
      tab_char = '│',
      highlight = 'Comment',
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        'help',
        'alpha',
        'dashboard',
        'snacks_explorer',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'lazyterm',
      },
    },
  },
}