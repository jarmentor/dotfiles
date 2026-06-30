return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>tf',
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Format on save: ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'))
      end,
      desc = '[T]oggle [F]ormat on save',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Global toggle (<leader>tf) or per-buffer flag (set during focus-lost
      -- autosave) — skip formatting so we don't rewrite whole legacy files.
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true, markdown = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      tex = { 'latexindent' },
      bib = { 'bibtex-tidy' },
      php = { 'phpcbf' },
    },
    formatters = {
      prettier = {
        options = {
          ft_parsers = {
            markdown = 'markdown',
          },
        },
      },
    },
  },
}
