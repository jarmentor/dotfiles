return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  config = function()
    require('no-neck-pain').setup({
      width = 120,
      autocmds = {
        enableOnVimEnter = false,
        enableOnTabEnter = false,
        reloadOnColorSchemeChange = true,
      },
      mappings = {
        enabled = true,
        toggle = '<Leader>nn',
        toggleLeft = '<Leader>nnl',
        toggleRight = '<Leader>nnr',
        widthUp = '<Leader>nn=',
        widthDown = '<Leader>nn-',
      },
    })
  end,
}