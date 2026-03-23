-- lua/apiarist/plugins/render-markdown.lua
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  init = function()
    -- Rose Pine-themed highlight groups (set early to prevent flash)
    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#1f1d2e' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = '#26233a', fg = '#f6c177' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeBorder', { fg = '#26233a' })
  end,
  opts = {
    preset = 'obsidian',
    -- Configure window options to disable native concealment
    win_options = {
      conceallevel = {
        default = 0,
        rendered = 3,
      },
    },
    -- File size limit to prevent lag on large documents
    max_file_size = 10.0, -- 10MB limit
    debounce = 100, -- 100ms debounce delay
    -- Anti-conceal feature - hide rendering on cursor line
    anti_conceal = {
      enabled = true,
    },
    -- Callout configuration for Obsidian compatibility
    callout = {
      note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
      tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
      important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
      warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
      caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    },
    -- Link configuration
    link = {
      enabled = true,
      image = '󰥶 ',
      email = '󰀓 ',
      hyperlink = '󰌹 ',
      highlight = 'RenderMarkdownLink',
    },
    -- Code block configuration
    code = {
      enabled = true,
      sign = false,
      style = 'full',
      width = 'full',
      left_pad = 1,
      right_pad = 1,
      border = 'thin',
      above = '▄',
      below = '▀',
      highlight = 'RenderMarkdownCode',
      highlight_inline = 'RenderMarkdownCodeInline',
      highlight_border = 'RenderMarkdownCodeBorder',
    },
    -- Heading configuration
    heading = {
      enabled = true,
      sign = true,
      position = 'overlay',
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      signs = { '󰫎 ' },
      width = 'full',
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = false,
      border_virtual = false,
      border_prefix = false,
      above = '▄',
      below = '▀',
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
    },
    -- Checkbox configuration
    checkbox = {
      enabled = true,
      position = 'inline',
      unchecked = {
        icon = '󰄱 ',
        highlight = 'RenderMarkdownUnchecked',
        scope_highlight = nil,
      },
      checked = {
        icon = '󰱒 ',
        highlight = 'RenderMarkdownChecked',
        scope_highlight = nil,
      },
      custom = {
        todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
      },
    },
    -- Bullet configuration
    bullet = {
      enabled = true,
      icons = { '●', '○', '◆', '◇' },
      left_pad = 0,
      right_pad = 0,
      highlight = 'RenderMarkdownBullet',
    },
    -- Table configuration
    pipe_table = {
      enabled = true,
      preset = 'none',
      style = 'full',
      cell = 'padded',
      min_width = 0,
      border = {
        '┌', '┬', '┐',
        '├', '┼', '┤',
        '└', '┴', '┘',
        '│', '─',
      },
      alignment_indicator = '━',
      head = 'RenderMarkdownTableHead',
      row = 'RenderMarkdownTableRow',
      filler = 'RenderMarkdownTableFill',
    },
    -- LaTeX math support
    latex = {
      enabled = true,
      converter = 'latex2text',
      highlight = 'RenderMarkdownMath',
      top_pad = 0,
      bottom_pad = 0,
    },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)
  end,
}