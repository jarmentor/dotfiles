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
        local nnp = require('no-neck-pain')
        
        -- Check if plugin is properly initialized before calling enable/disable
        if width > 140 then
          if not nnp.state or not nnp.state.enabled then
            nnp.enable()
          end
        elseif width < 120 then
          if nnp.state and nnp.state.enabled then
            nnp.disable()
          end
        end
      end,
    })
  end,
}