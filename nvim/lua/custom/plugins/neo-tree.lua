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
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        never_show = {
          '.DS_Store',
        },
        always_show_by_pattern = {
          '.env*',
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      hijack_netrw_behavior = 'open_default',
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
    -- Add a Neovim mapping for Shift+\
    vim.api.nvim_set_keymap('n', '<S-\\>', ':Neotree close<CR>', { noremap = true, silent = true, desc = 'Close NeoTree' })
  end,
}
