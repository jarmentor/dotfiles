return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      backdrop = 0.95,
      width = 0.7,
      height = 1,
      options = {
        signcolumn = 'no',
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = '0',
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = true },
      tmux = { enabled = true },
      kitty = {
        enabled = false,
        font = '+4',
      },
      alacritty = {
        enabled = false,
        font = '14',
      },
      wezterm = {
        enabled = false,
        font = '+4',
      },
    },
  },
}
