return {
  {
    'hrsh7th/nvim-cmp',
    version = false, -- always use latest commits
    event = 'InsertEnter', -- lazy load for insert mode
    dependencies = {
      'hrsh7th/cmp-buffer', -- buffer source
      'hrsh7th/cmp-path', -- path source
      'hrsh7th/cmp-cmdline', -- cmdline source (for ':' and '/')
      'hrsh7th/cmp-nvim-lsp', -- LSP completion (if using LSP)
      'L3MON4D3/LuaSnip', -- snippet engine
      'saadparwaiz1/cmp_luasnip', -- snippet source
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local cmp_window = require 'cmp.utils.window'

      -- Override border style for completion windows
      cmp_window.info_border_hl = 'FloatBorder'
      cmp_window.info_winblend = 10 -- slight transparency

      ---------------------------------------------------------------------------
      -- 1. INSERT-MODE CONFIGURATION (Buffer, Path, LSP, Snippets)
      ---------------------------------------------------------------------------
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        window = {
          completion = cmp.config.window.bordered(), -- rounded border popup
          documentation = cmp.config.window.bordered(),
        },
      }

      ---------------------------------------------------------------------------
      -- 2. COMMAND-LINE (“/” & “?”) SEARCH COMPLETION
      ---------------------------------------------------------------------------
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }, -- fuzzy search current buffer  [oai_citation:21‡GitHub](https://github.com/hrsh7th/cmp-cmdline?utm_source=chatgpt.com) [oai_citation:22‡Reddit](https://www.reddit.com/r/neovim/comments/1c570xf/can_someone_help_me_get_commandline_autocomplete/?tl=it&utm_source=chatgpt.com)
        },
        window = {
          completion = cmp.config.window.bordered(), -- border for search popup
          documentation = cmp.config.window.bordered(),
        },
      })

      ---------------------------------------------------------------------------
      -- 3. COMMAND-LINE (“:”) PATH & EX-COMMAND COMPLETION
      ---------------------------------------------------------------------------
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }, -- complete filesystem paths
        }, {
          {
            name = 'cmdline', -- complete Vim’s Ex commands
            option = {
              ignore_cmds = { 'Man', '!' }, -- ignore manual pages and shell commands if preferred  [oai_citation:23‡GitHub](https://github.com/hrsh7th/cmp-cmdline?utm_source=chatgpt.com) [oai_citation:24‡Vi and Vim Stack Exchange](https://vi.stackexchange.com/questions/43814/how-to-set-cmp-zsh-completion-source-for-commands-nvim-cmp-stuff?utm_source=chatgpt.com)
            },
          },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
