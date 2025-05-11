return {
  'folke/snacks.nvim',
  event = 'VimEnter',
  cmd = {
    'SnacksDashboard',
    'SnacksToggleDim',
    'SnacksToggleInlayHints',
  },
  opts = {
    toggle = {},
    quickfile = {},
    dashboard = {
      formats = {
        key = function(item)
          return { { '[', hl = 'special' }, { item.key, hl = 'key' }, { ']', hl = 'special' } }
        end,
      },
      sections = {
        {
          section = 'header',
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
      indent = 2,
      padding = 2,
    },
    terminal = {},
    dim = {},
    notifier = {
      enabled = true,
      timeout = 5000,
      style = {
        border = 'rounded',
        max_width = 90,
        min_height = 2,
        icons = { info = ' ', warn = ' ', error = ' ', success = ' ' },
      },
    },
  },
  keys = {
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>uh',
      function()
        require('snacks').toggle.inlay_hints()
      end,
      desc = 'Snacks: Toggle inlay hints',
    },
    {
      '<leader>uD',
      function()
        Snacks.toggle.dim()
      end,
      desc = 'Snacks: Toggle dim buffers',
    },
    {
      '<leader>tt',
      function()
        Snacks.terminal()
      end,
      desc = 'Snacks: Toggle Terminal',
    },
  },
}
