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
      integrations = {
        snacks = {
          enabled = true,
        },
      },
    })

    -- Auto-enable for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        require('no-neck-pain').enable()
      end,
    })

    -- Auto-enable when window is wide enough (>140 columns)
    vim.api.nvim_create_autocmd('VimResized', {
      callback = function()
        local width = vim.o.columns
        if width > 140 then
          require('no-neck-pain').enable()
        elseif width < 120 then
          require('no-neck-pain').disable()
        end
      end,
    })
  end,
}