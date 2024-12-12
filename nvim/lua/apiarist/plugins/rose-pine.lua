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
    }
  end,
  init = function()
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'rose-pine'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
