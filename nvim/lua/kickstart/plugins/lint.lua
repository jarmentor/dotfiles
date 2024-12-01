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
    end,
  },
}
