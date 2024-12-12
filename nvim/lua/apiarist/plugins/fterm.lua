return {
  'numToStr/FTerm.nvim',
  config = function()
    require('FTerm').setup {
      border = 'double',
      dimensions = {
        height = 0.6,
        width = 0.7,
      },
    }

    vim.keymap.set('n', '<leader>tt', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true, desc = 'Toggle Floating Terminal' })
    vim.keymap.set('t', '<leader>tt', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true, desc = 'Toggle Floating Terminal' })
  end,
}
