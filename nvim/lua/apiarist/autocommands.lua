vim.api.nvim_create_user_command('TrimTrailingSpaces', function(opts)
  -- Use the range provided in opts.line1 and opts.line2
  local range = opts.range
  -- If no range is provided, use the entire buffer
  if range == nil then
    vim.cmd '%s/\\s\\+$//e' -- Remove trailing spaces for the whole file
  else
    -- Remove trailing spaces for the specific range
    vim.cmd(string.format('%d,%d s/\\s\\+$//e', opts.line1, opts.line2))
  end
end, { range = true, desc = 'Remove trailing spaces (with optional range)' })

vim.api.nvim_create_user_command('ToggleLineNumbers', 'set number! | set relativenumber!', {})
vim.api.nvim_create_user_command('SaveAll', 'wa', {})
vim.api.nvim_create_user_command('BackupFile', function()
  -- Get the current file name
  local filename = vim.fn.expand '%'
  -- Get the current timestamp using strftime
  local timestamp = os.date '%Y%m%d%H%M%S'
  -- Create a backup filename
  local backup_filename = filename .. '.' .. timestamp .. '.bak'
  -- Perform the backup using the system's copy command
  vim.cmd(string.format('silent !cp %s %s', filename, backup_filename))
  -- Print a message to the user
  vim.api.nvim_out_write('Backup created at ' .. backup_filename .. '\n')
  -- Reload the file to ensure no changes
  vim.cmd 'edit!'
end, {})

vim.api.nvim_create_user_command('GitResetBuffer', function()
  -- Prompt the user for confirmation
  local confirm = vim.fn.confirm('Are you sure you want to reset the current buffer?', '&Yes\n&No', 2)

  -- If the user presses 'Yes', proceed with the reset
  if confirm == 1 then
    -- Perform the git reset and reload the file
    vim.cmd 'silent !git checkout -- % | edit!'
    vim.api.nvim_out_write 'Buffer has been reset to the latest commit.\n'
  else
    -- If the user presses 'No', just show a message and do nothing
    vim.api.nvim_out_write 'Git reset cancelled.\n'
  end
end, { desc = 'Git reset with confirmation' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
--

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add autocmd for buffer formatting before save for jsx etc.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.js', '*.ts', '*.jsx', '*.tsx' },
  callback = function()
    vim.lsp.buf.format { async = false }
  end,
})

-- Automatically return to the last edit position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_pos = vim.fn.line '\'"'
    if last_pos > 0 and last_pos <= vim.fn.line '$' then
      vim.cmd 'normal! g`"'
    end
  end,
})
