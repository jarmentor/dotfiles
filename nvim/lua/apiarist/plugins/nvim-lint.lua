return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- phpcs: resolve project-local binary + ruleset per buffer via autocmd
      -- nvim-lint here wants static tables for cmd/args, so rebind on BufEnter.
      local phpcs = lint.linters.phpcs
      phpcs.cmd = 'phpcs'
      phpcs.args = { '-q', '--report=json', '-s', '-' }

      local function resolve_phpcs()
        if vim.bo.filetype ~= 'php' then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == '' then
          return
        end
        -- Walk up and pick the first ancestor containing vendor/bin/phpcs.
        -- Avoids stopping at a nested composer.json without installed deps.
        local cmd_bin = 'phpcs'
        for dir in vim.fs.parents(bufname) do
          local candidate = dir .. '/vendor/bin/phpcs'
          if vim.fn.executable(candidate) == 1 then
            cmd_bin = candidate
            break
          end
        end
        phpcs.cmd = cmd_bin
        phpcs.args = {
          '-q',
          '--report=json',
          '-s',
          '--stdin-path=' .. bufname,
          '-',
        }
      end
      -- Linter setup for specific filetypes
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        json = { 'jsonlint' },
        php = { 'phpcs' },
      }

      -- Create autocommand to run linting on BufEnter, BufWritePost, InsertLeave
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      -- Linting autocommand with condition
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.o.buftype ~= '' then
            return
          end
          -- Resolve phpcs cmd/args before try_lint for php buffers
          if vim.bo.filetype == 'php' then
            resolve_phpcs()
          end
          lint.try_lint()
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
