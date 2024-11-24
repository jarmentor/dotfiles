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
    }
  end,
}
