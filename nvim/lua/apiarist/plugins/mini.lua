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
    -- - ysiw) - [Y]ou [S]urround [I]nner [W]ord [)]Paren
    -- - ds'   - [D]elete [S]urround [']quotes
    -- - cs)'  - [C]hange [S]urround [)] [']
    require('mini.surround').setup {
      mappings = {
        add = 'ys', -- Add surround (vim-surround style)
        delete = 'ds', -- Delete surround (vim-surround style)
        find = '', -- Disable find (rarely used)
        highlight = '', -- Disable highlight (rarely used)
        replace = 'cs', -- Change surround (vim-surround style)
        update_n_lines = '', -- Disable update (rarely used)
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
