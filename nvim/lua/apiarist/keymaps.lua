--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Capital W should also write the file
vim.keymap.set('n', ':W', '<cmd>w<CR>', { noremap = true, silent = true })

-- Capital Q should quit
vim.keymap.set('n', ':Q', '<cmd>q<CR>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Easy splits: horizontal and vertical
vim.keymap.set('n', '<leader>-', '<cmd>split<CR>', { desc = 'Horizontal split window' })
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Vertical split window' })

-- Moving Lines Around
vim.keymap.set('n', '<S-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<S-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { desc = 'Move block down' })
vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { desc = 'Move block up' })

vim.keymap.set('n', 'I', vim.lsp.buf.hover, { desc = 'Show Hover Information' })

-- Buffer management
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<CR>', { desc = '[B]uffer [O]nly (close others)' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { desc = 'New [T]ab' })
vim.keymap.set('n', '<leader>bt', '<cmd>tabnew<CR>', { desc = '[B]uffer in new [T]ab' })
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })

-- Window resizing
vim.keymap.set('n', '<C-w>H', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-w>L', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-w>J', '<cmd>resize -5<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-w>K', '<cmd>resize +5<CR>', { desc = 'Increase window height' })

-- Better window management
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch [W]indow' })
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = '[W]indow [D]elete/close' })
vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = '[W]indow split horizontally' })
vim.keymap.set('n', '<leader>w|', '<C-w>v', { desc = '[W]indow split vertically' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = '[W]indow [O]nly (close others)' })

-- Quickfix and location list navigation
vim.keymap.set('n', '[q', '<cmd>cprevious<CR>', { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '[l', '<cmd>lprevious<CR>', { desc = 'Previous location list' })
vim.keymap.set('n', ']l', '<cmd>lnext<CR>', { desc = 'Next location list' })

-- Better text navigation
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down (visual line)' })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up (visual line)' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Unique selected lines
vim.keymap.set('v', '<leader>u', ':sort u<CR>gv', { desc = '[U]nique selected lines' })

-- Center search results
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result (centered)' })

-- Save with Ctrl+S
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })

-- Toggle options
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle [W]rap' })
vim.keymap.set('n', '<leader>tn', '<cmd>set number! relativenumber!<CR>', { desc = '[T]oggle [N]umber' })
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = '[T]oggle [S]pell' })

-- Toggle diagnostics (linting errors)
vim.keymap.set('n', '<leader>te', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '[T]oggle diagnostic [E]rrors' })

-- Harper LSP spelling navigation and correction
vim.keymap.set('n', ']s', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
end, { desc = 'Next spelling issue' })

vim.keymap.set('n', '[s', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT })
end, { desc = 'Previous spelling issue' })

-- Better spelling correction that selects the whole word
vim.keymap.set('n', '<leader>sp', function()
  -- Select the word under cursor first
  vim.cmd('normal! viw')
  vim.lsp.buf.code_action()
end, { desc = '[S]pelling [P]roposals' })
vim.keymap.set('n', '<leader>tz', '<cmd>ZenMode<CR>', { desc = '[T]oggle [Z]en Mode' })

-- Toggle markdown checkboxes
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed

  if line:match '%- %[ %]' then
    local new_line = line:gsub('%- %[ %]', '- [x]')
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
  elseif line:match '%- %[x%]' then
    local new_line = line:gsub('%- %[x%]', '- [ ]')
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
  else
    -- If line has text but no checkbox, add unchecked checkbox at the beginning
    local trimmed = line:match '^%s*(.-)%s*$' -- trim whitespace
    if trimmed and trimmed ~= '' then
      local indent = line:match '^(%s*)' or ''
      local new_line = indent .. '- [ ] ' .. trimmed
      vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
    else
      -- Empty line, just add checkbox
      local indent = line:match '^(%s*)' or ''
      local new_line = indent .. '- [ ] '
      vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
    end
  end
end

vim.keymap.set('n', '<leader>k', toggle_checkbox, { desc = 'Toggle markdown checkbox' })
vim.keymap.set('n', '<leader>tc', toggle_checkbox, { desc = '[T]oggle markdown [C]heckbox' })

-- Custom gt for Accelo tickets and tasks
local function open_ticket()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  
  -- Get Accelo base URL from environment variable
  local base_url = vim.env.ACCELO_BASE_URL
  if not base_url then
    print('Error: ACCELO_BASE_URL environment variable not set')
    return
  end

  -- Find tk pattern (support issues)
  local ticket_pattern = 'tk(%d+)'
  local start_pos, end_pos, ticket_id = string.find(line, ticket_pattern)

  if ticket_id then
    -- Check if cursor is on the tk pattern
    if col >= start_pos - 1 and col <= end_pos then
      local url = string.format('%s/?action=view_support_issue&id=%s', base_url, ticket_id)
      vim.fn.system(string.format('open "%s"', url))
      print(string.format('Opening support issue tk%s in browser', ticket_id))
      return
    end
  end

  -- Find task pattern (tasks) - # is optional
  local task_pattern = 'task #?(%d+)'
  start_pos, end_pos, ticket_id = string.find(line, task_pattern)

  if ticket_id then
    -- Check if cursor is on the task pattern
    if col >= start_pos - 1 and col <= end_pos then
      local url = string.format('%s/?action=view_task&id=%s', base_url, ticket_id)
      vim.fn.system(string.format('open "%s"', url))
      print(string.format('Opening task %s in browser', ticket_id))
      return
    end
  end

  print('No ticket or task pattern found under cursor')
end

vim.keymap.set('n', 'gt', open_ticket, { desc = 'Open Accelo ticket under cursor' })

-- Custom commands
vim.api.nvim_create_user_command('Wrap', function()
  vim.opt.wrap = true
end, { desc = 'Enable line wrapping' })

vim.api.nvim_create_user_command('NoWrap', function()
  vim.opt.wrap = false
end, { desc = 'Disable line wrapping' })

vim.api.nvim_create_user_command('Numbers', function()
  vim.opt.number = true
  vim.opt.relativenumber = true
end, { desc = 'Enable line numbers and relative numbers' })

vim.api.nvim_create_user_command('NoNumbers', function()
  vim.opt.number = false
  vim.opt.relativenumber = false
end, { desc = 'Disable line numbers and relative numbers' })
