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

-- NOTE: JS/TS formatting handled by conform.nvim (see plugins/conform.lua)

-- Automatically return to the last edit position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_pos = vim.fn.line '\'"'
    if last_pos > 0 and last_pos <= vim.fn.line '$' then
      vim.cmd 'normal! g`"'
    end
  end,
})

-- Enable inlay hints for phpbuffers
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client.name == 'phpactor' and client.supports_method 'textDocument/inlayHint' then
      -- Enable for this buffer
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'startuptime', 'qf', 'lspinfo', 'man', 'checkhealth' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Highlight on yanking (copying) text - enhanced
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 300 }
  end,
})

-- Auto-create directories when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Remove trailing whitespace on save (limited to text files to avoid corrupting binaries)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.lua', '*.js', '*.ts', '*.jsx', '*.tsx', '*.php', '*.py', '*.md', '*.txt', '*.yaml', '*.yml', '*.json', '*.css', '*.scss', '*.html', '*.vue', '*.svelte', '*.astro', '*.tex', '*.bib', '*.sh', '*.zsh', '*.bash' },
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Auto-save on focus lost (silent - no spam)
vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  callback = function()
    -- Skip special buffer types
    local excluded_ft = { 'neo-tree', 'TelescopePrompt', 'lazy', 'mason', 'noice', 'snacks_dashboard', 'aerial' }
    if vim.tbl_contains(excluded_ft, vim.bo.filetype) then
      return
    end
    if vim.bo.modifiable and vim.bo.modified and vim.fn.expand '%' ~= '' and not vim.bo.readonly then
      vim.cmd 'silent! write'
    end
  end,
})

-- Better word wrapping for markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
  end,
})

-- Auto-reload files when they change externally
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})
