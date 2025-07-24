-- buffer cycling
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })

-- buffer navigation
vim.keymap.set('n', '<C-1>', ':BufferLineGoToBuffer 1<CR>', { desc = 'Go to buffer 1', silent = true })
vim.keymap.set('n', '<C-2>', ':BufferLineGoToBuffer 2<CR>', { desc = 'Go to buffer 2', silent = true })
vim.keymap.set('n', '<C-3>', ':BufferLineGoToBuffer 3<CR>', { desc = 'Go to buffer 3', silent = true })
vim.keymap.set('n', '<C-4>', ':BufferLineGoToBuffer 4<CR>', { desc = 'Go to buffer 4', silent = true })
vim.keymap.set('n', '<C-5>', ':BufferLineGoToBuffer 5<CR>', { desc = 'Go to buffer 5', silent = true })

-- Smart buffer closing function
local function smart_close_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local modified = vim.bo[bufnr].modified

  -- Always force close these buffer types
  local force_close_types = {
    'help',
    'quickfix',
    'qf',
    'loclist',
    'terminal',
    'nofile',
    'acwrite',
  }

  -- Check if buffer is a scratch/temporary buffer
  local is_scratch = bufname == ''
    or vim.tbl_contains(force_close_types, filetype)
    or vim.bo[bufnr].buftype ~= ''
    or bufname:match '^/tmp/'
    or bufname:match '^term://'
    or not vim.bo[bufnr].modifiable

  if is_scratch or not modified then
    -- Safe to force close scratch buffers or unmodified buffers
    vim.cmd 'bdelete!'
  else
    -- Regular file with modifications - use normal bdelete (will prompt)
    vim.cmd 'bdelete'
  end
end

-- buffer management
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete current buffer', silent = true })
vim.keymap.set('n', '<leader>ba', ':bufdo bd<CR>', { desc = 'Delete all buffers', silent = true })
vim.keymap.set('n', '<leader>x', smart_close_buffer, { desc = 'Smart close current buffer', silent = true })
vim.keymap.set('n', '<leader>o', ':BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>', { desc = 'Close all other buffers', silent = true })
vim.keymap.set('n', '<leader>n', ':enew<CR>', { desc = 'New buffer', silent = true })

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
