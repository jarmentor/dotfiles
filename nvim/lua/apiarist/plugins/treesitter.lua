return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 
        'bash', 'c', 'cpp', 'css', 'diff', 'dockerfile', 'git_config', 'git_rebase', 'gitcommit', 'gitignore',
        'go', 'html', 'javascript', 'json', 'lua', 'luadoc', 'make', 'markdown', 'markdown_inline', 
        'php', 'python', 'query', 'regex', 'rust', 'sql', 'toml', 'typescript', 'vim', 'vimdoc', 'yaml'
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby', 'css' },
      },
      indent = {
        enable = true,
        disable = { 'ruby', 'css' },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
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
