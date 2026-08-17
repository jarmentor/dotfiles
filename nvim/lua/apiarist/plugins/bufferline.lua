-- buffer cycling is on <Tab> / <S-Tab> and ]b / [b (see keymaps.lua)

-- buffer navigation
vim.keymap.set('n', '<C-1>', ':BufferLineGoToBuffer 1<CR>', { desc = 'Go to buffer 1', silent = true })
vim.keymap.set('n', '<C-2>', ':BufferLineGoToBuffer 2<CR>', { desc = 'Go to buffer 2', silent = true })
vim.keymap.set('n', '<C-3>', ':BufferLineGoToBuffer 3<CR>', { desc = 'Go to buffer 3', silent = true })
vim.keymap.set('n', '<C-4>', ':BufferLineGoToBuffer 4<CR>', { desc = 'Go to buffer 4', silent = true })
vim.keymap.set('n', '<C-5>', ':BufferLineGoToBuffer 5<CR>', { desc = 'Go to buffer 5', silent = true })

-- buffer management (kept under the <leader>b group so <leader>o/x/n stay free
-- for the Obsidian / Trouble / notifier prefixes they collided with)
vim.keymap.set('n', '<leader>ba', function()
  Snacks.bufdelete.all()
end, { desc = 'Delete all buffers', silent = true })
vim.keymap.set('n', '<leader>bN', ':enew<CR>', { desc = 'New buffer', silent = true })

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      highlights = require 'rose-pine.plugins.bufferline',
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        numbers = 'none',
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = 'thin',
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        offsets = { { filetype = 'snacks_explorer', text = 'File Explorer', padding = 1 } },
      },
    }
  end,
}
