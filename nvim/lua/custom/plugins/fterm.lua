return {
  'numToStr/FTerm.nvim',
  config = function()
    require('FTerm').setup {
      border = 'double',
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    }

    -- Keybindings for toggling, opening, and closing the terminal
    -- Toggle the terminal in normal and terminal mode
    vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true, desc = 'Toggle Floating Terminal' })
    vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true, desc = 'Toggle Floating Terminal' })

    -- Open terminal with <leader>tt
    vim.keymap.set('n', '<leader>tt', '<CMD>lua require("FTerm").open()<CR>', { noremap = true, silent = true, desc = 'Open Floating Terminal' })
    vim.keymap.set('t', '<leader>tt', '<C-\\><C-n><CMD>lua require("FTerm").open()<CR>', { noremap = true, silent = true, desc = 'Open Floating Terminal' })

    -- Close the terminal with <leader>tc
    vim.keymap.set('n', '<leader>tc', '<CMD>lua require("FTerm").close()<CR>', { noremap = true, silent = true, desc = 'Close Floating Terminal' })
    vim.keymap.set('t', '<leader>tc', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', { noremap = true, silent = true, desc = 'Close Floating Terminal' })

    -- Exit the terminal with <leader>tx
    vim.keymap.set('n', '<leader>tx', '<CMD>lua require("FTerm").exit()<CR>', { noremap = true, silent = true, desc = 'Exit Floating Terminal' })
    vim.keymap.set('t', '<leader>tx', '<C-\\><C-n><CMD>lua require("FTerm").exit()<CR>', { noremap = true, silent = true, desc = 'Exit Floating Terminal' })
  end,
}
