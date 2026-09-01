-- Filetypes oxfmt doesn't cover, so trimming is all they get.
local trim_only = {
  'python',
  'text',
  'yaml',
  'css',
  'scss',
  'html',
  'vue',
  'svelte',
  'astro',
  'sh',
  'bash',
  'zsh',
}

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        -- Without a range conform formats the whole buffer, even from a selection
        local range = nil
        local mode = vim.fn.mode()
        if mode == 'v' or mode == 'V' or mode == '\22' then
          local a, b = vim.fn.getpos 'v', vim.fn.getpos '.'
          if a[2] > b[2] or (a[2] == b[2] and a[3] > b[3]) then
            a, b = b, a
          end
          range = { start = { a[2], a[3] - 1 }, ['end'] = { b[2], b[3] } }
        end
        require('conform').format { async = true, lsp_format = 'fallback', range = range }
      end,
      mode = { 'n', 'v' },
      desc = '[F]ormat buffer/selection',
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
  opts = function()
    local formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'oxfmt' },
      typescript = { 'oxfmt' },
      javascriptreact = { 'oxfmt' },
      typescriptreact = { 'oxfmt' },
      json = { 'oxfmt' },
      jsonc = { 'oxfmt' },
      markdown = { 'oxfmt' }, -- keeps trailing double-space hard breaks
      tex = { 'latexindent' },
      bib = { 'bibtex-tidy' },
      php = { 'phpcbf' },
    }
    -- Trimming here keeps one BufWritePre writer; two left extmarks stale
    for _, ft in ipairs(trim_only) do
      formatters_by_ft[ft] = { 'trim_whitespace' }
    end

    return {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Buffer flag is set during focus-lost autosave, so legacy repos don't
        -- get surprise whole-file diffs
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Languages without a well standardized style
        local disable_filetypes = { c = true, cpp = true, markdown = true }
        return {
          timeout_ms = 500,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
        }
      end,
      formatters_by_ft = formatters_by_ft,
    }
  end,
}
