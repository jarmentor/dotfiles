return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
    { '<S-\\>', ':Neotree close<CR>', desc = 'Close NeoTree' },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
    -- Add a Neovim mapping for Shift+\
    vim.api.nvim_set_keymap('n', '<S-\\>', ':Neotree close<CR>', { noremap = true, silent = true, desc = 'Close NeoTree' })
  end,
}
