return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting

    null_ls.setup {
      dependencies = {
        'nvimtools/none-ls-extras.nvim',
      },
      sources = {
        -- Prettier configuration with valid filetypes
        formatting.prettier.with {
          filetypes = {
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'vue',
            'css',
            'scss',
            'less',
            'html',
            'json',
            'jsonc',
            'yaml',
            'markdown',
            'graphql',
            'handlebars',
          },
        },
      },
      -- Ensure proper LSP method handling
      on_attach = function(client, bufnr)
        -- Ensure client is fully initialized before accessing capabilities
        if client.resolved_capabilities and client.resolved_capabilities.document_formatting then
          -- Only set the formatexpr if the client supports document formatting
          vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr')
        end
      end,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    }
  end,
}
