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

    -- NOTE: Surround functionality provided by nvim-surround (has HTML/emmet support)

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
