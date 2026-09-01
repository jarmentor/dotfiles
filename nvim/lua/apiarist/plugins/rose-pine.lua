return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require('rose-pine').setup {
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
      highlight_groups = {
        -- More obvious visual selection
        Visual = { bg = 'iris', blend = 30 },
      },
    }

    -- Not in `init`: that runs before setup, dropping transparency and Visual above
    vim.cmd.colorscheme 'rose-pine'
    vim.cmd.hi 'Comment gui=none'
  end,
}
