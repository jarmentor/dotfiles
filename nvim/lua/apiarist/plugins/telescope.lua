return {
  -- ───────────────────────────────────────────────────
  --  Telescope core plugin
  -- ───────────────────────────────────────────────────
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- lock to latest tagged release
  event = 'VeryLazy',

  -- ───────────────────────────────────────────────────
  --  Dependencies
  -- ───────────────────────────────────────────────────
  dependencies = {
    'nvim-lua/plenary.nvim',

    -- Native FZF sorter (only built if `make` exists)
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- Replaces vim.ui.select / input with Telescope pop‑ups
    'nvim-telescope/telescope-ui-select.nvim',

    -- Icons (optional, needs Nerd Font)
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  -- ───────────────────────────────────────────────────
  --  Lazy‑load trigger keys (so Telescope isn’t loaded
  --  until you actually press one of these)
  -- ───────────────────────────────────────────────────
  keys = {
    {
      '<leader>sf',
      function()
        require('telescope.builtin').find_files()
      end,
      desc = '[S]earch [F]iles',
    },

    {
      '<leader><leader>',
      function()
        require('telescope.builtin').buffers()
      end,
      desc = 'Switch Buffers',
    },
  },

  -- ───────────────────────────────────────────────────
  --  Setup
  -- ───────────────────────────────────────────────────
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'
    local map = vim.keymap.set

    telescope.setup {
      defaults = {
        path_display = { 'smart' },
        file_ignore_patterns = {
          '%.git/',
          '%.cache/',
          '%.o$',
          '%.a$',
          '%.out$',
          '%.class$',
          '%.pdf$',
          '%.mkv$',
          '%.mp4$',
          '%.zip$',
        },
        mappings = {
          i = { ['<C-t>'] = actions.open_qflist },
          n = { ['<C-t>'] = actions.open_qflist },
        },
      },

      pickers = {
        find_files = { hidden = true },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Load extensions (gracefully skip if compile failed)
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- ───────────────────────────────────────────────
    --  Keymaps (beyond the lazy‑load triggers)
    -- ───────────────────────────────────────────────
    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sl', builtin.git_commits, { desc = '[S]earch Git [L]og' })
    map('n', '<leader>sc', builtin.colorscheme, { desc = '[S]earch [C]olorschemes' })
    map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>sy', builtin.lsp_document_symbols, { desc = '[S]earch S[Y]mbols' })
    map('n', '<leader>si', builtin.lsp_implementations, { desc = '[S]earch [I]mplementations' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sb', builtin.git_branches, { desc = '[S]earch [B]ranches' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })

    -- In‑buffer fuzzy search (dropdown theme)
    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzy‑find in current buffer' })

    -- Live‑grep limited to open buffers
    map('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Search Neovim config files
    map('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- Git status with preview
    map('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })

    -- Git file history for current file
    map('n', '<leader>gh', builtin.git_bcommits, { desc = '[G]it [H]istory (current file)' })

    -- Search git files (respects .gitignore)
    map('n', '<leader>sg', builtin.git_files, { desc = '[S]earch [G]it files' })
  end,
}
