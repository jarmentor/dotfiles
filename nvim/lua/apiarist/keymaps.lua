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

-- Center search results
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result (centered)' })

-- Save with Ctrl+S
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'Save file' })

-- Toggle options
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = '[T]oggle [W]rap' })
vim.keymap.set('n', '<leader>tn', '<cmd>set number! relativenumber!<CR>', { desc = '[T]oggle [N]umber' })
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = '[T]oggle [S]pell' })
vim.keymap.set('n', '<leader>tz', '<cmd>ZenMode<CR>', { desc = '[T]oggle [Z]en Mode' })

-- Toggle markdown checkboxes
vim.keymap.set('n', '<leader>k', function()
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed

  if line:match '%- %[ %]' then
    local new_line = line:gsub('%- %[ %]', '- [x]')
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
  elseif line:match '%- %[x%]' then
    local new_line = line:gsub('%- %[x%]', '- [ ]')
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { new_line })
  end
end, { desc = 'Toggle markdown checkbox' })
