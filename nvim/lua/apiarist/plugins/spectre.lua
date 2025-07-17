return {
  -- Find and replace across project
  'nvim-pack/nvim-spectre',
  build = false,
  cmd = 'Spectre',
  opts = { open_cmd = 'noswapfile vnew' },
  keys = {
    {
      '<leader>Sr',
      function()
        require('spectre').open()
      end,
      desc = 'Replace in files (Spectre)',
    },
    {
      '<leader>Sw',
      function()
        require('spectre').open_visual { select_word = true }
      end,
      desc = 'Replace Word (Spectre)',
    },
    {
      '<leader>Sf',
      function()
        require('spectre').open_file_search { select_word = true }
      end,
      desc = 'Replace in current file (Spectre)',
    },
  },
}