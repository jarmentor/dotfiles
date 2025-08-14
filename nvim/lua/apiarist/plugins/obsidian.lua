-- lua/apiarist/plugins/obsidian.lua
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'folke/snacks.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { '<leader>on', '<cmd>Obsidian new<cr>', desc = 'New Obsidian note' },
    { '<leader>oo', '<cmd>Obsidian search<cr>', desc = 'Search Obsidian notes' },
    { '<leader>os', '<cmd>Obsidian quick_switch<cr>', desc = 'Quick switch note' },
    { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = 'Show backlinks' },
    { '<leader>oT', '<cmd>Obsidian tags<cr>', desc = 'Search tags' },
    { '<leader>oi', '<cmd>Obsidian template<cr>', desc = 'Insert template' },
    { '<leader>op', '<cmd>Obsidian paste_img<cr>', desc = 'Paste image' },
    { '<leader>ol', '<cmd>Obsidian link<cr>', desc = 'Create link' },
    { '<leader>of', '<cmd>Obsidian follow_link<cr>', desc = 'Follow link' },
    { '<leader>od', '<cmd>Obsidian dailies<cr>', desc = 'Daily notes' },
    { '<leader>oy', '<cmd>Obsidian yesterday<cr>', desc = "Yesterday's note" },
    { '<leader>ot', '<cmd>Obsidian today<cr>', desc = "Today's note" },
    { '<leader>om', '<cmd>Obsidian tomorrow<cr>', desc = "Tomorrow's note" },
    { '<leader>ow', '<cmd>Obsidian workspace<cr>', desc = 'Switch workspace' },
  },
  config = function()
    -- Disable conceallevel to work with render-markdown.nvim
    vim.opt.conceallevel = 0
    
    -- Set up buffer-local keymaps for markdown files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        
        -- Override 'gf' mapping to work on markdown/wiki links
        vim.keymap.set('n', 'gf', '<cmd>Obsidian follow_link<cr>', vim.tbl_extend('force', opts, { desc = 'Follow link' }))
        
        -- Toggle check-boxes
        vim.keymap.set('n', '<leader>ch', function()
          vim.cmd('Obsidian toggle_checkbox')
        end, vim.tbl_extend('force', opts, { desc = 'Toggle checkbox' }))
        
        -- Quick checkbox creation
        vim.keymap.set('n', '<leader>cb', function()
          local line = vim.api.nvim_get_current_line()
          local indent = line:match '^%s*'
          vim.api.nvim_set_current_line(indent .. '- [ ] ')
          vim.api.nvim_feedkeys('A', 'n', false)
        end, vim.tbl_extend('force', opts, { desc = 'Create checkbox' }))
      end,
    })
    
    require('obsidian').setup {
      -- Disable legacy commands to get rid of warnings
      legacy_commands = false,
      
      workspaces = {
        {
          name = 'personal',
          path = tostring '/Volumes/Development/Notebook/',
        },
      },

      -- Daily notes
      daily_notes = {
        folder = 'daily',
        date_format = '%Y-%m-%d',
        alias_format = '%B %-d, %Y',
        template = 'daily-note.md',
      },

      -- Completion
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },


      -- Note ID generation
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          suffix = tostring(os.time())
        end
        return tostring(os.date '%Y%m%d') .. '-' .. suffix
      end,

      -- Optional, customize the frontmatter data
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, for templates
      templates = {
        subdir = 'templates',
        date_format = '%Y-%m-%d-%a',
        time_format = '%H:%M',
        substitutions = {},
      },

      -- Optional, configure key mappings
      follow_url_func = function(url)
        vim.fn.jobstart { 'open', url } -- Mac OS
      end,

      -- Optional, by default commands like `:Obsidian today` will open in current buffer
      open_notes_in = 'current',
      
      -- Checkbox configuration (replaces ui.checkboxes order)
      checkbox = {
        order = { ' ', 'x', '>', '~' },
      },

      -- Specify how to handle attachments
      attachments = {
        img_folder = 'assets/imgs',
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            link_path = vault_relative_path
          else
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format('![%s](%s)', display_name, link_path)
        end,
      },

      -- Open configuration (replaces use_advanced_uri and open_app_foreground)
      open = {
        use_advanced_uri = false,
        func = function(uri)
          vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
        end,
      },

      picker = {
        name = 'snacks.pick',
        note_mappings = {
          new = '<C-x>',
          insert_link = '<C-l>',
        },
        tag_mappings = {
          tag_note = '<C-x>',
          insert_tag = '<C-l>',
        },
      },

      -- Disable UI features to work with render-markdown.nvim
      ui = {
        enable = false,
      },
    }
  end,
}
