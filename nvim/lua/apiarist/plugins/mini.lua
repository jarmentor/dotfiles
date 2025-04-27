return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup {
      mappings = {
        add = 'sa', -- Add surround
        delete = 'sd', -- Delete surround
        find = 'sf', -- Find surround
        highlight = 'sh', -- Highlight surround
        replace = 'sr', -- Replace surround
        update_n_lines = 'sn', -- Update `n_lines`
      },
    }

    -- Replace Comment.nvim with mini.comment for commenting support
    require('mini.comment').setup()

    local ms = require 'mini.statusline'
    -- Custom location format: LINE:COLUMN with fixed width
    ---@diagnostic disable-next-line: duplicate-set-field
    ms.section_location = function()
      return '%2l:%-2v'
    end

    ms.setup {
      use_icons = vim.g.have_nerd_font,
    }

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
