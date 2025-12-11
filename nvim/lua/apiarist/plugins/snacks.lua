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
      '<leader>nh',
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
      '<leader>tm',
      function()
        require('snacks').terminal()
      end,
      desc = 'Snacks: Toggle Terminal',
    },
    {
      '\\',
      function()
        require('snacks').explorer()
      end,
      desc = 'Explorer',
    },
    -- File finding
    {
      '<leader>sf',
      function()
        require('snacks').picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader><leader>',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Switch Buffers',
    },
    {
      '<leader>sG',
      function()
        require('snacks').picker.git_files()
      end,
      desc = '[S]earch [G]it files',
    },
    {
      '<leader>sn',
      function()
        require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    -- Search
    {
      '<leader>sg',
      function()
        require('snacks').picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep { search = vim.fn.expand '<cword>' }
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>/',
      function()
        require('snacks').picker.lines()
      end,
      desc = '[/] Search in current buffer',
    },
    -- Git
    {
      '<leader>sl',
      function()
        require('snacks').picker.git_log()
      end,
      desc = '[S]earch Git [L]og',
    },
    {
      '<leader>sb',
      function()
        require('snacks').picker.git_branches()
      end,
      desc = '[S]earch [B]ranches',
    },
    {
      '<leader>gs',
      function()
        require('snacks').picker.git_status()
      end,
      desc = '[G]it [S]tatus',
    },
    -- Help and navigation
    {
      '<leader>sh',
      function()
        require('snacks').picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>s.',
      function()
        require('snacks').picker.recent()
      end,
      desc = '[S]earch Recent Files',
    },
    -- Document/Workspace symbols
    {
      '<leader>sy',
      function()
        require('snacks').picker.lsp_symbols()
      end,
      desc = '[S]earch S[Y]mbols (document)',
    },
    {
      '<leader>ws',
      function()
        require('snacks').picker.lsp_workspace_symbols()
      end,
      desc = '[W]orkspace [S]ymbols',
    },
    -- Colorschemes
    {
      '<leader>sc',
      function()
        require('snacks').picker.colorschemes()
      end,
      desc = '[S]earch [C]olorschemes',
    },
    -- Diagnostics
    {
      '<leader>sD',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sd',
      function()
        require('snacks').picker.diagnostics_buffer()
      end,
      desc = '[S]earch [d]iagnostics Buffer',
    },
    -- LSP implementations
    {
      '<leader>si',
      function()
        require('snacks').picker.lsp_implementations()
      end,
      desc = '[S]earch [I]mplementations',
    },
    -- Telescope builtin (for picker discovery)
    {
      '<leader>ss',
      function()
        require('snacks').picker.commands()
      end,
      desc = '[S]earch [S]elect Commands',
    },
    -- Search open files
    {
      '<leader>s/',
      function()
        require('snacks').picker.grep { search_dirs = vim.tbl_map(vim.api.nvim_buf_get_name, vim.api.nvim_list_bufs()) }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    -- Marks picker
    {
      '<leader>sm',
      function()
        require('snacks').picker.marks()
      end,
      desc = '[S]earch [M]arks',
    },
    -- Registers picker
    {
      '<leader>sr',
      function()
        require('snacks').picker.registers()
      end,
      desc = '[S]earch [R]egisters',
    },
    -- Git hunks picker
    {
      '<leader>gh',
      function()
        require('snacks').picker.git_diff()
      end,
      desc = '[G]it [H]unks',
    },
    -- Line picker
    {
      '<leader>sl',
      function()
        require('snacks').picker.lines()
      end,
      desc = '[S]earch [L]ines',
    },
    -- Git stash picker
    {
      '<leader>gS',
      function()
        require('snacks').picker.git_stash()
      end,
      desc = '[G]it [S]tash',
    },
    -- Git log for current file
    {
      '<leader>gf',
      function()
        require('snacks').picker.git_log_file()
      end,
      desc = '[G]it log [F]ile history',
    },
    -- Git log for current line
    {
      '<leader>gL',
      function()
        require('snacks').picker.git_log_line()
      end,
      desc = '[G]it [L]og line history',
    },
    -- Git grep through repository
    {
      '<leader>gG',
      function()
        require('snacks').picker.git_grep()
      end,
      desc = '[G]it [G]rep repository',
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
          key = 'd',
          desc = 'Daily Note',
          icon = '󰃭 ',
          indent = 0,
          padding = 1,
          pane = 1,
          action = function()
            require('lazy').load { plugins = { 'obsidian.nvim' } }
            vim.cmd 'Obsidian today'
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
    explorer = {
      enabled = true,
      follow_file = true,
      auto_close = true,
      hidden = true,
    },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      hidden = true,
    },
    scope = { enabled = false }, -- toggle off if not needed
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
