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

    -- NOTE: Folding capabilities are added in lsp-config.lua to avoid
    -- re-configuring all LSP servers here (which would override other settings)

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
