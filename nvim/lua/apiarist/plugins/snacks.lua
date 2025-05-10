return {
  'folke/snacks.nvim',
  event = 'VimEnter',
  cmd = {
    'SnacksDashboard',
    'SnacksToggleDim',
    'SnacksToggleInlayHints',
  },
  opts = {
    dashboard = {
      header = { 'Welcome back, 👋', '' },
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
    dim = {
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
      -- animate scopes. Enabled by default for Neovim >= 0.10
      -- Works on older versions but has to trigger redraws during animation.
      animate = {
        enabled = vim.fn.has 'nvim-0.10' == 1,
        easing = 'outQuad',
        duration = {
          step = 20, -- ms per step
          total = 300, -- maximum duration
        },
      },
      -- what buffers to dim
      filter = function(buf)
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype
        if bt ~= '' or ft == 'NvimTree' or ft == 'toggleterm' then
          return false
        end
        return true
      end,
    },
    notifier = {
      enabled = true,
      timeout = 5000,
      style = {
        border = 'rounded',
        max_width = 80,
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
