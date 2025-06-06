-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

-- Set the line number defaults
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, for resizing splits
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- don't wrap by default
vim.opt.wrap = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- Better search experience
vim.opt.hlsearch = true

-- Enable persistent undo
vim.opt.undolevels = 10000

-- Better completion experience
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Enable true color support
vim.opt.termguicolors = true

-- Faster syntax highlighting
vim.opt.synmaxcol = 300

-- Better diff mode
vim.opt.diffopt:append('iwhite,algorithm:patience')

-- Improve performance for large files
vim.opt.lazyredraw = true

-- Better indentation
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Show matching brackets
vim.opt.showmatch = true

-- Enable folding with better defaults
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
