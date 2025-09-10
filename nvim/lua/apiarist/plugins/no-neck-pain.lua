return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  config = function()
    require('no-neck-pain').setup({
      width = 120,
      debug = false, -- set to true if you want to see what's happening
      autocmds = {
        enableOnVimEnter = false,
        enableOnTabEnter = false,
        reloadOnColorSchemeChange = true,
        skipEnteringNoNeckPainBuffer = true,
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
        aerial = {
          position = 'right',
          reopen = true,
        },
      },
    })

    -- Handle aerial window closing - simple approach
    vim.api.nvim_create_autocmd('BufWinLeave', {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
        
        if filetype == 'aerial' then
          -- Delay refresh after aerial closes
          vim.defer_fn(function()
            local nnp = require('no-neck-pain')
            if nnp.state and nnp.state.enabled then
              -- Just refresh by toggling off and on instead of using resize
              nnp.disable()
              vim.schedule(function()
                nnp.enable()
              end)
            end
          end, 150)
        end
      end,
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
        
        -- Add safety check for valid windows
        local current_win = vim.api.nvim_get_current_win()
        if not vim.api.nvim_win_is_valid(current_win) then
          return
        end
        
        -- Check if we're in a special window that should be ignored
        local buf = vim.api.nvim_win_get_buf(current_win)
        local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
        local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
        
        -- Skip if we're in aerial, snacks, or other special windows
        if filetype == 'aerial' or 
           filetype == 'snacks_dashboard' or 
           filetype == 'snacks_notif' or
           filetype == 'snacks_terminal' or
           filetype == 'snacks_lazygit' or
           buftype == 'nofile' or
           buftype == 'terminal' then
          return
        end
        
        -- Check if plugin is properly initialized before calling enable/disable
        if width > 140 then
          if not nnp.state or not nnp.state.enabled then
            vim.schedule(function()
              nnp.enable()
            end)
          end
        elseif width < 120 then
          if nnp.state and nnp.state.enabled then
            vim.schedule(function()
              nnp.disable()
            end)
          end
        end
      end,
    })
  end,
}