return {
  'kevinhwang91/nvim-ufo',
  event = 'BufRead',
  dependencies = { 'kevinhwang91/promise-async' },
  config = function()
    -- Enable foldcolumn
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local language_servers = require('lspconfig').util.available_servers()
    for _, ls in ipairs(language_servers) do
      require('lspconfig')[ls].setup {
        capabilities = capabilities,
      }
    end

    -- Configure folding provider: first LSP, then indent as fallback
    require('ufo').setup {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'lsp', 'indent' }
      end,
    }

    -- Key mappings for folding actions
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
  end,
}
