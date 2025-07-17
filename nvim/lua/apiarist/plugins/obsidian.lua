-- lua/apiarist/plugins/obsidian.lua
return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'New Obsidian note' },
    { '<leader>oo', '<cmd>ObsidianSearch<cr>', desc = 'Search Obsidian notes' },
    { '<leader>os', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Quick switch note' },
    { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = 'Show backlinks' },
    { '<leader>oT', '<cmd>ObsidianTags<cr>', desc = 'Search tags' },
    { '<leader>oi', '<cmd>ObsidianTemplate<cr>', desc = 'Insert template' },
    { '<leader>op', '<cmd>ObsidianPasteImg<cr>', desc = 'Paste image' },
    { '<leader>ol', '<cmd>ObsidianLink<cr>', desc = 'Create link' },
    { '<leader>of', '<cmd>ObsidianFollowLink<cr>', desc = 'Follow link' },
    { '<leader>od', '<cmd>ObsidianDailies<cr>', desc = 'Daily notes' },
    { '<leader>oy', '<cmd>ObsidianYesterday<cr>', desc = "Yesterday's note" },
    { '<leader>ot', '<cmd>ObsidianToday<cr>', desc = "Today's note" },
    { '<leader>om', '<cmd>ObsidianTomorrow<cr>', desc = "Tomorrow's note" },
    { '<leader>ow', '<cmd>ObsidianWorkspace<cr>', desc = 'Switch workspace' },
  },
  config = function()
    vim.opt.conceallevel = 2
    require('obsidian').setup({
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

    -- Mappings (in addition to keys above)
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Quick checkbox creation
      ['<leader>cb'] = {
        action = function()
          local line = vim.api.nvim_get_current_line()
          local indent = line:match '^%s*'
          vim.api.nvim_set_current_line(indent .. '- [ ] ')
          vim.api.nvim_feedkeys('A', 'n', false)
        end,
        opts = { buffer = true },
      },
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

    -- Optional, by default commands like `:ObsidianToday` will open in current buffer
    open_notes_in = 'current',

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

    -- Optional, set to true if you use the Obsidian Advanced URI plugin
    use_advanced_uri = false,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground
    open_app_foreground = false,

    picker = {
      name = 'telescope.nvim',
      mappings = {
        new = '<C-x>',
        insert_link = '<C-l>',
      },
    },

    -- Optional, configure additional syntax highlighting
    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      },
      bullets = { char = '•', hl_group = 'ObsidianBullet' },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianBullet = { bold = true, fg = '#89ddff' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },
  })
  end,
}
