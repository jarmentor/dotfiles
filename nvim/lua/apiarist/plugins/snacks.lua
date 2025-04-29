return {
  'folke/snacks.nvim',
  event = 'VeryLazy',
  cmd = {
    'SnacksScratch',
    'SnacksScratchSelect',
    'SnacksQuickfile',
    'SnacksDashboard',
    'SnacksToggleDim',
    'SnacksToggleInlayHints',
  },
  opts = {
    scratch = {
      enabled = true,
      default_ft = 'markdown',
      open_cmd = 'vsplit',
      template = function()
        return { '# Scratch • ' .. os.date '%Y-%m-%d', '' }
      end,
      persist = false,
    },
    dashboard = {
      header = { 'Welcome back, 👋', '' },
      formats = {
        key = function(item)
          return { { '[', hl = 'special' }, { item.key, hl = 'key' }, { ']', hl = 'special' } }
        end,
      },
      sections = {
        { section = 'terminal', cmd = 'fortune -s | cowsay', hl = 'header', padding = 1, indent = 8 },
        { icon = '', title = 'Workspaces', section = 'projects', padding = 1 },
        { icon = '', title = 'Recent Files', section = 'recent_files', padding = 1 },
        { icon = '', title = 'Find File', action = 'Telescope find_files', padding = 1 },
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
    quickfile = {
      enabled = true,
      dir = '~/notes/%Y/%m/',
      extension = 'md',
      template = function(path)
        return { '# ' .. vim.fn.fnamemodify(path, ':t:r'), '', '—✎' }
      end,
      create_dir = true,
      on_create = function(path)
        vim.cmd('edit ' .. path)
        if vim.fn.exists '*vim.lsp.buf.format' == 1 then
          vim.lsp.buf.format { async = false }
        end
        vim.fn.jobstart({ 'git', 'add', path }, { detach = true })
      end,
    },
  },
  keys = {
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
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
