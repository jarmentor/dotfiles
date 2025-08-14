-- lua/apiarist/plugins/markdown-editing.lua
return {
  'tadmccorkle/markdown.nvim',
  ft = 'markdown',
  opts = {
    -- Text object mappings
    mappings = {
      inline_surround_toggle = 'gs', -- toggle inline style (bold, italic)
      inline_surround_toggle_line = 'gss', -- toggle inline style for line
      inline_surround_delete = 'ds', -- delete inline style
      inline_surround_change = 'cs', -- change inline style
      link_add = 'gl', -- add link
      link_follow = 'gx', -- follow link
      go_curr_heading = ']c', -- go to current heading
      go_parent_heading = ']p', -- go to parent heading
      go_next_heading = ']]', -- go to next heading
      go_prev_heading = '[[', -- go to previous heading
    },
    -- Inline style configuration
    inline_surround = {
      emphasis = {
        key = 'e',
        txt = '*',
      },
      strong = {
        key = 's',
        txt = '**',
      },
      strikethrough = {
        key = 't',
        txt = '~~',
      },
      code_span = {
        key = 'c',
        txt = '`',
      },
    },
    -- Link configuration
    link = {
      paste = {
        enable = true,
      },
    },
    -- Table of contents
    toc = {
      omit_heading = 'toc omit heading',
      omit_section = 'toc omit section',
      -- Custom heading style
      markers = { '-' },
    },
    -- Hook configuration for custom behaviors
    hooks = {
      follow_link = nil, -- use default link following
    },
    -- Text objects configuration
    text_objects = {
      block_quote = {
        enable = true,
        key = 'q',
      },
      code_block = {
        enable = true,
        key = 'c',
      },
      fenced_code_block = {
        enable = true,
        key = 'C',
      },
      heading = {
        enable = true,
        key = 'h',
      },
      list_item = {
        enable = true,
        key = 'i',
      },
      section = {
        enable = true,
        key = 's',
      },
      table = {
        enable = true,
        key = 't',
      },
      table_cell = {
        enable = true,
        key = 'd',
      },
      link = {
        enable = true,
        key = 'l',
      },
    },
  },
}