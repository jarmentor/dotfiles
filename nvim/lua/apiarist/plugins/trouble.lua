return {
  'folke/trouble.nvim',
  opts = {
    modes = {
      diagnostics = {
        mode = 'diagnostics',
        preview = {
          type = 'split',
          relative = 'win',
          position = 'right',
          size = 0.3,
        },
      },
      -- Trouble's split default is a fixed 30 columns for every mode; symbol names
      -- need more. A fraction <= 1 is read as a share of the parent window, so this
      -- scales with terminal width. Scoped here: other splits stay at 30.
      symbols = {
        win = { size = 0.25 },
      },
      todos = {
        mode = 'todo',
        preview = {
          type = 'split',
          relative = 'win',
          position = 'right',
          size = 0.3,
        },
      },
    },
    icons = {
      indent = {
        top = '│ ',
        middle = '├╴',
        last = '└╴',
        fold_open = ' ',
        fold_closed = ' ',
        ws = '  ',
      },
      folder_closed = ' ',
      folder_open = ' ',
      kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        String = ' ',
        Struct = '󰆼 ',
        TypeParameter = ' ',
        Variable = '󰀫 ',
      },
    },
  },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>xe',
      '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>',
      desc = 'Errors Only (Trouble)',
    },
    {
      '<leader>xt',
      '<cmd>Trouble todo toggle<cr>',
      desc = 'TODOs (Trouble)',
    },
    {
      '<leader>xT',
      '<cmd>Trouble todo toggle filter={tag={TODO,FIXME,HACK,WARN,PERF,NOTE,TEST}}<cr>',
      desc = 'All TODOs/FIXMEs (Trouble)',
    },
    {
      '<leader>xs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    -- Call hierarchy. Nothing else in this config surfaces callers/callees.
    {
      '<leader>xi',
      '<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>',
      desc = 'Incoming Calls (Trouble)',
    },
    {
      '<leader>xo',
      '<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>',
      desc = 'Outgoing Calls (Trouble)',
    },
    -- Cycle the open Trouble list from the source buffer, without focusing it.
    -- Guarded: with no view open these resolve to no mode and Trouble raises
    -- "No mode specified" rather than doing nothing.
    {
      ']x',
      function()
        local trouble = require 'trouble'
        if trouble.is_open() then
          trouble.next { jump = true }
        end
      end,
      desc = 'Next Trouble Item',
    },
    {
      '[x',
      function()
        local trouble = require 'trouble'
        if trouble.is_open() then
          trouble.prev { jump = true }
        end
      end,
      desc = 'Prev Trouble Item',
    },
  },
}
