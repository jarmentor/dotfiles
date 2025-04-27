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
    { '\\', ':Neotree toggle<CR>', desc = 'NeoTree toggle' },
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
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
