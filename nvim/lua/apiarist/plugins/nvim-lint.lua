return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Linter setup for specific filetypes
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        json = { 'jsonlint' },
        php = { 'phpcs' },
      }

      -- Create autocommand to run linting on BufEnter, BufWritePost, InsertLeave
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      -- Linting autocommand with condition
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- If we're not hovering, do the linting
          if vim.o.buftype == '' then
            lint.try_lint()
          end
        end,
      })

      -- Show diagnostics in hover popup on cursor hold
      vim.api.nvim_create_autocmd('CursorHold', {
        group = lint_augroup,
        callback = function()
          -- Only show hover if diagnostics are enabled
          if not vim.diagnostic.is_enabled() then
            return
          end

          -- Get diagnostics, filtering out hints (harper) when diagnostics are toggled off
          local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

          if #diagnostics > 0 then
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = 'rounded',
              source = 'always',
              prefix = ' ',
            })
          end
        end,
      })

      -- Note: updatetime is set in options.lua (250ms)
      -- Removed from here to avoid conflict

      -- Keymap for manual diagnostic hover
      vim.keymap.set('n', '<leader>l', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
    end,
  },
}
