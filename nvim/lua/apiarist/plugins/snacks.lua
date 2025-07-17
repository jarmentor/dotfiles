return {
  'folke/snacks.nvim',
  priority = 1000, -- ensure early setup
  lazy = false, -- load immediately to register autocommands

  -- Only load when these commands or keymaps are used (still "loaded", but usage is deferred)
  cmd = {
    'SnacksDashboard',
    'SnacksToggleDim',
    'SnacksToggleInlayHints',
    'SnacksTerminal',
    'SnacksNotifierHistory',
  },
  keys = {
    {
      '<leader>n',
      function()
        require('snacks').notifier.show_history()
      end,
      desc = 'Snacks: Notification History',
    },
    {
      '<leader>uh',
      function()
        require('snacks').toggle.inlay_hints()
      end,
      desc = 'Snacks: Toggle Inlay Hints',
    },
    {
      '<leader>uD',
      function()
        require('snacks').toggle.dim()
      end,
      desc = 'Snacks: Toggle Dim Buffers',
    },
    {
      '<leader>tt',
      function()
        require('snacks').terminal()
      end,
      desc = 'Snacks: Toggle Terminal',
    },
  },

  opts = {
    -- Explicitly enable modules you want; unset or omit to disable
    toggle = { enabled = true },
    quickfile = { enabled = true },
    dashboard = {
      enabled = true,
      formats = {
        key = function(item)
          local k = item.key or '?' -- safe fallback if no key present
          return { { '[', hl = 'special' }, { k, hl = 'key' }, { ']', hl = 'special' } }
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
        {
          icon = ' ',
          key = 'd',
          desc = 'Daily Note',
          action = function()
            require('lazy').load { plugins = { 'obsidian.nvim' } }
            vim.cmd 'ObsidianToday'
          end,
        },
        {
          section = 'recent_files',
          title = 'Recent Files',
          icon = ' ',
          indent = 2,
          padding = 1,
          pane = 1, -- use pane 1 (single column)
        },
        {
          section = 'projects',
          title = 'Projects',
          icon = ' ',
          indent = 2,
          padding = 1,
          pane = 1,
        },
        {
          section = 'terminal',
          title = 'Git Status',
          icon = ' ',
          enabled = function()
            return require('snacks.git').get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
          pane = 1,
        },
        { section = 'startup', pane = 1 },
      },
      indent = vim.o.columns < 100 and 1 or 2, -- dynamic for narrow windows
      padding = vim.o.columns < 100 and 1 or 2,
    },
    terminal = { enabled = true },
    dim = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000, -- shorter toast time
      style = {
        border = 'rounded',
        max_width = 90,
        min_width = 20,
        max_height = 10, -- avoid overly tall popups
        min_height = 2,
        icons = {
          info = ' ',
          warn = ' ',
          error = ' ',
          success = ' ',
          debug = ' ',
        },
      },
    },

    -- Example additional modules you might enable:
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    scope = { enabled = false }, -- toggle off if not needed
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
