return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- master is frozen/archived (Apr 2026), does not work on nvim 0.12+
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      -- Languages that depend on vim's regex highlighting alongside treesitter
      local additional_regex = { ruby = true, css = true }
      -- Languages where treesitter indent misbehaves
      local disable_indent = { ruby = true, css = true }

      -- The main rewrite drops auto_install/ensure_installed and the module
      -- system: highlight + indent are enabled per-buffer ourselves. This
      -- autocmd reproduces the old auto_install behavior — install the parser
      -- on first encounter, then start treesitter once it lands.
      local config = require('nvim-treesitter.config')

      local function start(buf, lang)
        vim.treesitter.start(buf, lang)
        if additional_regex[lang] then
          vim.bo[buf].syntax = 'on'
        end
        if not disable_indent[lang] then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then
            return
          end

          if vim.tbl_contains(config.get_installed('parsers'), lang) then
            start(buf, lang)
          elseif vim.tbl_contains(config.get_available(), lang) then
            -- known parser, not yet installed: fetch then start (old auto_install)
            require('nvim-treesitter').install({ lang }):await(function()
              if vim.api.nvim_buf_is_valid(buf) and vim.tbl_contains(config.get_installed('parsers'), lang) then
                start(buf, lang)
              end
            end)
          end
          -- unknown ft (plugin UI buffers like snacks_dashboard): no parser, skip
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- Uses builtin vim.treesitter only (needs nvim 0.9+, just parsers) —
    -- unaffected by the master->main rewrite.
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        zindex = 20,
      }
    end,
  },
}
