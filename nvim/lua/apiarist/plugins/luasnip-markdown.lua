-- lua/apiarist/plugins/luasnip-markdown.lua
return {
  'L3MON4D3/LuaSnip',
  dependencies = { 'rafamadriz/friendly-snippets' },
  config = function()
    local luasnip = require('luasnip')
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node
    local f = luasnip.function_node
    local d = luasnip.dynamic_node
    local sn = luasnip.snippet_node
    
    -- Helper function to get current date
    local function get_date()
      return os.date('%Y-%m-%d')
    end
    
    -- Helper function to get current timestamp
    local function get_timestamp()
      return os.date('%Y-%m-%d %H:%M:%S')
    end
    
    -- Helper function to get current time
    local function get_time()
      return os.date('%H:%M')
    end
    
    -- Markdown-specific snippets
    luasnip.add_snippets('markdown', {
      -- Daily note template
      s('daily', {
        t('# '), f(function()
          return os.date('%B %d, %Y')
        end), t({ '', '' }),
        t({ '## Tasks', '' }),
        t({ '- [ ] ', '' }),
        i(1, 'First task'),
        t({ '', '', '## Notes', '' }),
        i(2, 'Daily notes...'),
        t({ '', '', '## Reflection', '' }),
        i(3, 'What went well? What could be improved?'),
        t({ '', '', '---', '' }),
        t('**Tags:** '), i(4, '#daily'),
        t({ '', '**Created:** ' }), f(get_timestamp),
      }),
      
      -- Meeting note template
      s('meeting', {
        t('# '), i(1, 'Meeting Title'), t(' - '), f(get_date),
        t({ '', '' }),
        t({ '**Date:** ' }), f(get_date),
        t({ '', '**Time:** ' }), f(get_time),
        t({ '', '**Attendees:** ' }), i(2, 'List attendees'),
        t({ '', '', '## Agenda', '' }),
        t({ '1. ' }), i(3, 'First agenda item'),
        t({ '', '', '## Notes', '' }),
        i(4, 'Meeting notes...'),
        t({ '', '', '## Action Items', '' }),
        t({ '- [ ] ' }), i(5, 'First action item'),
        t({ '', '', '## Next Meeting', '' }),
        i(6, 'Next meeting date/time'),
        t({ '', '', '---', '' }),
        t('**Tags:** '), i(7, '#meeting'),
      }),
      
      -- Project template
      s('project', {
        t('# '), i(1, 'Project Name'),
        t({ '', '' }),
        t({ '**Status:** ' }), i(2, 'In Progress'),
        t({ '', '**Priority:** ' }), i(3, 'Medium'),
        t({ '', '**Due Date:** ' }), i(4, 'TBD'),
        t({ '', '**Owner:** ' }), i(5, 'Name'),
        t({ '', '', '## Overview', '' }),
        i(6, 'Brief project description...'),
        t({ '', '', '## Goals', '' }),
        t({ '- ' }), i(7, 'Primary goal'),
        t({ '', '', '## Tasks', '' }),
        t({ '- [ ] ' }), i(8, 'First task'),
        t({ '', '', '## Resources', '' }),
        i(9, 'Links, documents, contacts...'),
        t({ '', '', '## Notes', '' }),
        i(10, 'Additional notes...'),
        t({ '', '', '---', '' }),
        t('**Tags:** '), i(11, '#project'),
        t({ '', '**Created:** ' }), f(get_timestamp),
      }),
      
      -- Quick note template
      s('qnote', {
        t('# '), i(1, 'Quick Note'),
        t({ '', '' }),
        i(2, 'Content goes here...'),
        t({ '', '', '---', '' }),
        t('**Created:** '), f(get_timestamp),
        t({ '', '**Tags:** ' }), i(3, '#quick-note'),
      }),
      
      -- Code block with language
      s('code', {
        t('```'), i(1, 'language'),
        t({ '', '' }), i(2, 'code here'),
        t({ '', '```' }),
      }),
      
      -- Callouts (Obsidian style)
      s('note', {
        t('> [!NOTE]'),
        t({ '', '> ' }), i(1, 'Note content'),
      }),
      
      s('tip', {
        t('> [!TIP]'),
        t({ '', '> ' }), i(1, 'Tip content'),
      }),
      
      s('warning', {
        t('> [!WARNING]'),
        t({ '', '> ' }), i(1, 'Warning content'),
      }),
      
      s('important', {
        t('> [!IMPORTANT]'),
        t({ '', '> ' }), i(1, 'Important content'),
      }),
      
      s('caution', {
        t('> [!CAUTION]'),
        t({ '', '> ' }), i(1, 'Caution content'),
      }),
      
      -- Link creation
      s('link', {
        t('['), i(1, 'link text'), t(']('), i(2, 'url'), t(')'),
      }),
      
      -- Image insertion
      s('img', {
        t('!['), i(1, 'alt text'), t(']('), i(2, 'image path'), t(')'),
      }),
      
      -- Table template
      s('table', {
        t('| '), i(1, 'Header 1'), t(' | '), i(2, 'Header 2'), t(' | '), i(3, 'Header 3'), t(' |'),
        t({ '', '|----------|----------|----------|' }),
        t({ '', '| ' }), i(4, 'Cell 1'), t(' | '), i(5, 'Cell 2'), t(' | '), i(6, 'Cell 3'), t(' |'),
        t({ '', '| ' }), i(7, 'Cell 4'), t(' | '), i(8, 'Cell 5'), t(' | '), i(9, 'Cell 6'), t(' |'),
      }),
      
      -- Frontmatter template
      s('front', {
        t('---'),
        t({ '', 'title: "' }), i(1, 'Title'), t('"'),
        t({ '', 'date: ' }), f(get_date),
        t({ '', 'tags: [' }), i(2, 'tag1, tag2'), t(']'),
        t({ '', 'draft: ' }), i(3, 'false'),
        t({ '', '---', '', '' }),
        i(4),
      }),
      
      -- Task list
      s('tasks', {
        t('## Tasks'),
        t({ '', '' }),
        t('- [ ] '), i(1, 'First task'),
        t({ '', '- [ ] ' }), i(2, 'Second task'),
        t({ '', '- [ ] ' }), i(3, 'Third task'),
      }),
      
      -- Date stamp
      s('date', {
        f(get_date),
      }),
      
      -- Timestamp
      s('time', {
        f(get_timestamp),
      }),
      
      -- Quote block
      s('quote', {
        t('> '), i(1, 'Quote text'),
        t({ '', '> ' }),
        t({ '', '> — ' }), i(2, 'Author'),
      }),
    })
    
    -- Load friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    
    -- Key mappings for LuaSnip
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { silent = true })
    
    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true })
    
    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { silent = true })
  end,
}